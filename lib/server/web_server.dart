part of dart_force_mvc_lib;

class WebServer extends SimpleWebServer {
  
  final Logger log = new Logger('WebServer');
  
  Router router;
  ForceViewRender viewRender;
  
  String startPage = 'index.html';
  
  var wsPath;
  var port;
  var buildDir;
  var virDir;
  var bind_address = InternetAddress.ANY_IP_V6;
  
  Completer _completer;
  
  WebServer({wsPath: '/ws', port: 8080, host: null, buildPath: '../build' }) : super() {
    init(wsPath, port, host, buildPath);
    this.viewRender = new MustacheRender();
  }
  
  void on(String url, ControllerHandler controllerHandler, {method: RequestMethod.GET}) {
   _completer.future.whenComplete(() {
     this.router.serve(url, method: method).listen((HttpRequest req) {
       Model model = new Model();
       String view = controllerHandler(new ForceRequest(req), model);
       if (view != null) {
         // template rendering
         _send_template(req, model, view);
       } else {
         String data = JSON.encode(model.getData());
         _send_response(req.response, new ContentType("application", "json", charset: "utf-8"), data);
       }
     });
   }); 
  }
  
  void register(Object obj) {
      List<MirrorValue> mirrorValues = MirrorHelpers.getMirrorValues(obj, RequestMapping);
      List<MirrorValue> mirrorModels = MirrorHelpers.getMirrorValues(obj, ModelAttribute);
          
      for (MirrorValue mv in mirrorValues) {
            // execute all ! ! !
            on(mv.value, (ForceRequest req, Model model) {
              for (MirrorValue mvModel in mirrorModels) {
                
                InstanceMirror res = mvModel.instanceMirror.invoke(mvModel.memberName, []);
                
                if (res.hasReflectee) {
                  model.addAttribute(mvModel.value, res.reflectee);
                }
              }
              InstanceMirror res = mv.instanceMirror.invoke(mv.memberName, [req, model]);
              
              if (res.hasReflectee) {
                var view = res.reflectee;
                if (view is String) {
                  return view;
                }
                else {
                  return null;
                }
              }
            });
      }
  }
  
  void _send_template(HttpRequest req, Model model, String view) {
    this.viewRender.render(view, model.getData()).then((String result) {
      _send_response(req.response, new ContentType("text", "html", charset: "utf-8"), result);
    });
  }
  
  void _send_response(HttpResponse response, ContentType contentType, String result) {
    response
    ..statusCode = 200
    ..headers.contentType = contentType
    ..write(result)
      ..close();
  }
  
  void serveFile(String fileName, HttpRequest request) {
    Uri fileUri = Platform.script.resolve(fileName);
    virDir.serveFile(new File(fileUri.toFilePath()), request);
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
      virDir.jailRoot = false;
      virDir.allowDirectoryListing = true;
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
  }
  
}