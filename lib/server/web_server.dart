part of dart_force_mvc_lib;

class WebServer extends SimpleWebServer with ServingFiles {
  final Logger log = new Logger('WebServer');
	bool cors=false;
  Router router;
  ForceViewRender viewRender;
  ForceRegistry registry;

  SecurityContextHolder securityContext;
  InterceptorsCollection interceptors = new InterceptorsCollection();

  WebServer({host: "127.0.0.1",
             port: 8080,
             wsPath: '/ws',
             staticFiles: '../static/',
             clientFiles: '../build/web/',
             clientServe: true,
             views: "../views/",
             startPage: "index.html",
             cors:true}) :
               super(host, port, wsPath, staticFiles,
                     clientFiles, clientServe) {
    this.startPage = startPage;
    this.cors = cors;
    viewRender = new MustacheRender(views, clientFiles, clientServe);
    registry = new ForceRegistry(this);
    securityContext = new SecurityContextHolder(new NoSecurityStrategy());
    _scanning();
  }

  void _scanning() {
    this.registry.scanning();

    // Search for interceptors
    ClassSearcher<HandlerInterceptor> searcher = new ClassSearcher<HandlerInterceptor>();
    List<HandlerInterceptor> interceptorList = searcher.scan();

    interceptors.addAll(interceptorList);
  }

  void on(Pattern url, ControllerHandler controllerHandler, {method: RequestMethod.GET, bool authentication: false}) {
   _completer.future.whenComplete(() {
     this.router.serve(url, method: method).listen((HttpRequest req) {
       if (checkSecurity(req, authentication)) {
         _resolveRequest(req, controllerHandler);
       } else {
         Uri location = securityContext.redirectUri(req);
         req.response.redirect(location, status: 301);
       }
     });
   });
  }

  bool checkSecurity(HttpRequest req, auth) {
    if (auth) {
      return securityContext.checkAuthorization(req);
    } else {
      return true;
    }
  }

  void _resolveRequest(HttpRequest req, ControllerHandler controllerHandler) {
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
    this.registry.register(obj);
  }

  void _send_template(HttpRequest req, Model model, String view) {
    this.viewRender.render(view, model.getData()).then((String result) {
      _send_response(req.response, new ContentType("text", "html", charset: "utf-8"), result);
    });
  }

  void _send_response(HttpResponse response, ContentType contentType, String result) {
  	if(this.cors==true){
  		response
        ..headers.add("Access-Control-Allow-Origin", "*, ")
        ..headers.add("Access-Control-Allow-Methods", "POST, GET, OPTIONS")
        ..headers.add("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");
    }
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
    if (handleWs != null) {
      Stream<HttpRequest> stream = router.serve(this.wsPath);
        stream.listen((HttpRequest req) {
//          stream.transform(new WebSocketTransformer())
//                    .listen(handleWs);
          if(WebSocketTransformer.isUpgradeRequest(req)) {
             WebSocketTransformer.upgrade(req).then((WebSocket ws) {
                handleWs(ws, req);
             });
          }
        });
    }

    // Serve dart and static files (if not explicitly disabled by clientServe)
    _serveClient(staticFiles, clientFiles, clientServe);
  }

  void set strategy(SecurityStrategy strategy) {
    securityContext.strategy = strategy;
  }
  
  void loadValues(String path) => this.registry.loadValues(path);
}

