part of dart_force_mvc_lib;

class WebServer {
  
  final Logger log = new Logger('BasicServer');
  
  Router router;
  String startPage = 'index.html';
  
  var wsPath;
  var port;
  var buildDir;
  var virDir;
  var bind_address = InternetAddress.ANY_IP_V6;
  
  Completer _completer;
  
  WebServer({wsPath: '/ws', port: 8080, host: null, buildPath: '../build' }) {
    this.port = port;
    this.wsPath = wsPath;
    this._completer = new Completer.sync();
    if (host!=null) {
      this.bind_address = host;
    }
    buildDir = Platform.script.resolve(buildPath).toFilePath();
    if (!new Directory(buildDir).existsSync()) {
      log.severe("The 'build/' directory was not found. Please run 'pub build'.");
      return;
    } 
  }
  
  Future start([WebSocketHandler handleWs]) {
    HttpServer.bind(bind_address, port).then((server) { 
        _onStart(server, handleWs);
        _completer.complete(const []);
      });
    return _completer.future;
  }
  
  void on(String url, ControllerHandler controllerHandler, {method: "GET"}) {
   _completer.future.whenComplete(() {
     this.router.serve(url, method: method).listen((HttpRequest req) {
       Model model = new Model();
       String view = controllerHandler(req, model);
       if (view != null) {
         // template rendering
         resolveRendering(req, model, view);
       } else {
         req.response
         ..statusCode = 200
         ..headers.contentType = new ContentType("application", "json", charset: "utf-8")
         ..write(model.getData())
           ..close();
       }
     });
   }); 
  }
  
  void register(Object obj) {
    InstanceMirror myClassInstanceMirror = reflect(obj);
    ClassMirror MyClassMirror = myClassInstanceMirror.type;
   
    Iterable<DeclarationMirror> decls =
        MyClassMirror.declarations.values.where(
            (dm) => dm is MethodMirror && dm.isRegularMethod);
    decls.forEach((MethodMirror mm) {
      if (mm.metadata.isNotEmpty) {
        // var request = mm.metadata.first.reflectee;
        for (var im in mm.metadata) {
          if (im is RequestMapping) {
            var request = im;
            log.info("just a simple receiver method on -> $request");
            String name = (MirrorSystem.getName(mm.simpleName));
            Symbol memberName = mm.simpleName;
            
            on(request.value, (HttpRequest req, Model model) {
              log.info("execute this please!");
              InstanceMirror res = myClassInstanceMirror.invoke(memberName, [req, model]);
              
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
      }
    });
  }
  
  void resolveRendering(HttpRequest req, Model model, String view) {
    
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