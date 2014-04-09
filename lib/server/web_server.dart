part of dart_force_mvc_lib;

class WebServer extends SimpleWebServer with ServingFiles {
  
  final Logger log = new Logger('WebServer');
  
  Router router;
  ForceViewRender viewRender;
  
  String startPage = 'index.html';
  
  var wsPath;
  var port;
  var buildDir;
  var virDir;
  var bind_address = InternetAddress.ANY_IP_V6;
  var staticDir = 'static';
  
  Completer _completer;
  InterceptorsCollection interceptors = new InterceptorsCollection();
  
  WebServer({wsPath: '/ws', port: 8080, host: null, buildPath: '../build/web/', this.staticDir: 'static'}) : super() {
    init(wsPath, port, host, buildPath);
    this.viewRender = new MustacheRender();
    _scanning();
  }
  
  void _scanning() {
    Scanner<Controller, Object> classesHelper = new Scanner<Controller, Object>();
    List<Object> classes = classesHelper.scan();
    
    for (var obj in classes) {
      this.register(obj);
    }
    
    // search for interceptors
    ClassSearcher<HandlerInterceptor> searcher = new ClassSearcher<HandlerInterceptor>();
    List<HandlerInterceptor> interceptorList = searcher.scan();
    
    interceptors.addAll(interceptorList);
  }
  
  void on(Pattern url, ControllerHandler controllerHandler, {method: RequestMethod.GET}) {
   _completer.future.whenComplete(() {
     this.router.serve(url, method: method).listen((HttpRequest req) {
       Model model = new Model();
       ForceRequest forceRequest = new ForceRequest(req);
       interceptors.preHandle(forceRequest, model, this);
       var result = controllerHandler(forceRequest, model);
       interceptors.postHandle(forceRequest, model, this);
       if (result != null) {
         // template rendering
         if (result is String) {  
          _resolveView(result, req, model);
         } else if (result is Future) {
           Future future = result;
           future.then((e) {
             if (e is String) {
               _resolveView(e, req, model);
             } else {
               String data = JSON.encode(model.getData());
               _send_response(req.response, new ContentType("application", "json", charset: "utf-8"), data);
             }
           });
         }
       } else {
         String data = JSON.encode(model.getData());
         _send_response(req.response, new ContentType("application", "json", charset: "utf-8"), data);
       }
       interceptors.afterCompletion(forceRequest, model, this);
     });
   }); 
  }
  
  void _resolveView(String view, HttpRequest req, Model model) {
    if (view.startsWith("redirect:")) {
       Uri location = Uri.parse(view.substring(9));
       req.response.redirect(location, status: 301);
    } else {
       _send_template(req, model, view);
    }
  }
  
  void register(Object obj) {
      List<MetaDataValue<RequestMapping>> mirrorValues = new MetaDataHelper<RequestMapping>().getMirrorValues(obj);
      List<MetaDataValue<ModelAttribute>> mirrorModels = new MetaDataHelper<ModelAttribute>().getMirrorValues(obj);
          
      for (MetaDataValue mv in mirrorValues) {
            // execute all ! ! !
        PathAnalyzer pathAnalyzer = new PathAnalyzer(mv.object.value);
        UrlPattern urlPattern = new UrlPattern(pathAnalyzer.route);
        on(urlPattern, (ForceRequest req, Model model) {
            // prepare model  
            for (MetaDataValue mvModel in mirrorModels) {
                
                InstanceMirror res = mvModel.invoke([]);
                
                if (res != null && res.hasReflectee) {
                  model.addAttribute(mvModel.object.value, res.reflectee);
                }
            }
            // search for path variables
            for (var i = 0; pathAnalyzer.variables.length>i; i++) { 
              var variableName = pathAnalyzer.variables[i], 
                  value = urlPattern.parse(req.request.uri.path)[i];
              req.path_variables[variableName] = value;
            }
             
            List<dynamic> positionalArguments = _calculate_positionalArguments(mv, model, req);
            
            InstanceMirror res = mv.invoke(positionalArguments);
              
            if (res != null && res.hasReflectee) {
                return res.reflectee;
              }
           }, method: mv.object.method);
      }
  }
  
  List<dynamic> _calculate_positionalArguments(MetaDataValue<RequestMapping> mv, Model model, ForceRequest req) {
      List<dynamic> positionalArguments = new List<dynamic>();
      for (ParameterMirror pm in mv.parameters) {
          String name = (MirrorSystem.getName(pm.simpleName));
          
          if (pm.type is Model || name == 'model') {
            positionalArguments.add(model);
          } else if (pm.type is ForceRequest || name == 'req') {
            positionalArguments.add(req);
          } else if (pm.type is HttpSession || name == 'session') {
            positionalArguments.add(req.request.session);
          } else if (pm.type is HttpHeaders || name == 'headers') {
            positionalArguments.add(req.request.headers);
          } else {
            if (req.path_variables[name] != null) {
              positionalArguments.add(req.path_variables[name]);
            } else {
             for ( InstanceMirror im  in pm.metadata ) {
               if ( im.reflectee is PathVariable ) {
                 PathVariable pathVariable = im.reflectee;
                 if (req.path_variables[pathVariable.value] != null) {
                    positionalArguments.add(req.path_variables[pathVariable.value]);
                 }
               }
               if ( im.reflectee is RequestParam) {
                 RequestParam rp = im.reflectee;
                 if (req.request.uri.queryParameters[rp.value] != null) {
                   positionalArguments.add(req.request.uri.queryParameters[rp.value]);
                 } else {
                   positionalArguments.add(rp.defaultValue);
                 }
               }
             }
            }
          }
      }
      if (positionalArguments.isEmpty && mv.parameters.length == 2) {
           positionalArguments = [req, model];
      }
      return positionalArguments;
  }
  
  void _send_template(HttpRequest req, Model model, String view) {
    this.viewRender.render(view, model.getData()).then((String result) {
      _send_response(req.response, new ContentType("text", "html", charset: "utf-8"), _make_scripts_startwith_slash(result));
    });
  }
  
  String _make_scripts_startwith_slash(String result) {
    result = result.replaceAll("src=\"", "src=\"/");
    result = result.replaceAll("src=\"/http:/", "src=\"http:/");
    result = result.replaceAll("src=\"/../", "src=\"../");
    result = result.replaceAll("src='", "src='/");
    result = result.replaceAll("src='/http:/", "src='http:/");
    result = result.replaceAll("src='/../", "src='../");
    result = result.replaceAll("src='//", "src='/");
    result = result.replaceAll("src=\"//", "src=\"/");
    return result;
  }
  
  void _send_response(HttpResponse response, ContentType contentType, String result) {
    response
    ..statusCode = 200
    ..headers.contentType = contentType
    ..write(result)
      ..close();
  }
  
  void _onStart(server, [WebSocketHandler handleWs]) {
      log.info("Search server is running on "
          "'http://${Platform.localHostname}:$port/'");
      router = new Router(server);

      // The client will connect using a WebSocket. Upgrade requests to '/ws' and
      // forward them to 'handleWebSocket'.
      if (handleWs!=null) {
        router.serve(this.wsPath)
          .transform(new WebSocketTransformer())
            .listen(handleWs);
      }
      
      // Set up default handler. This will serve files from our 'build' directory.
      virDir = new http_server.VirtualDirectory(buildDir);
      // Disable jail-root, as packages are local sym-links.
      virDir..jailRoot = false
            ..allowDirectoryListing = true;
      virDir.directoryHandler = (dir, request) {
          // Redirect directory-requests to index.html files.
          var indexUri = new Uri.file(dir.path).resolve(startPage);
          virDir.serveFile(new File(indexUri.toFilePath()), request);
      };

      // Add an error page handler.
      virDir.errorPageHandler = (HttpRequest request) {
        log.warning("Resource not found ${request.uri.path}");
        request.response.statusCode = HttpStatus.NOT_FOUND;
        request.response.close();
      };

      // Serve everything not routed elsewhere through the virtual directory.
      virDir.serve(router.defaultStream);
      
      _dartFilesServing();
      _staticFilesServing();
  }

}