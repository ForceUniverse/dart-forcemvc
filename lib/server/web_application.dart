part of dart_force_mvc_lib;

@Deprecated("0.6.0") // use WebApplication instead!
class WebServer extends WebApplication {
  
  WebServer({host: "127.0.0.1",
               port: 8080,
               wsPath: '/ws',
               staticFiles: '../static/',
               clientFiles: '../build/web/',
               clientServe: true,
               views: "../views/",
               startPage: "index.html",
               cors:true}) :
                 super(host: host, port: port, wsPath: wsPath, staticFiles: staticFiles,
                       clientFiles: clientFiles, clientServe: clientServe, views: views, startPage: startPage, cors: cors);
  
}

class WebApplication extends SimpleWebServer with ServingFiles {
  final Logger log = new Logger('WebServer');
  
  bool cors=false;
  Router router;
  String views;
  ForceViewRender viewRender;
  ForceRegistry registry;

  SecurityContextHolder securityContext;
  InterceptorsCollection interceptors = new InterceptorsCollection();
  HandlerExceptionResolver exceptionResolver = new SimpleExceptionResolver();
  LocaleResolver localeResolver = new AcceptHeaderLocaleResolver();
  
  List<ResponseHook> responseHooks = new List<ResponseHook>();
  HttpRequestStreamer requestStreamer;
  
  ControllerHandler _notFound;

  WebApplication({host: "127.0.0.1",
             port: 8080,
             wsPath: '/ws',
             staticFiles: '../static/',
             clientFiles: '../build/web/',
             clientServe: true,
             this.views: "../views/",
             startPage: "index.html",
             cors:true}) :
               super(host, port, wsPath, staticFiles,
                     clientFiles, clientServe) {
    this.startPage = startPage;
    if(cors==true){ this.responseHooks.add(response_hook_cors); }
    registry = new ForceRegistry(this);
    securityContext = new SecurityContextHolder(new NoSecurityStrategy());
  }

  void _scanning() {
    this.registry.scanning();
  }

  void on(Pattern url, ControllerHandler controllerHandler, 
          {method: RequestMethod.GET, List<String> roles}) {
   _completer.future.whenComplete(() {
     this.router.serve(url, method: method).listen((HttpRequest req) {
       if (checkSecurity(req, roles)) {
         _resolveRequest(req, controllerHandler);
       } else {
         Uri location = securityContext.redirectUri(req);
         req.response.redirect(location, status: HttpStatus.MOVED_PERMANENTLY);
       }
     });
   });
  }
  
  void notFound(ControllerHandler controllerHandler) {
    this._notFound = controllerHandler;
  }
  
  void _notFoundHandling(HttpRequest request) {
     super._notFoundHandling(request);
     if (_notFound!=null) {
         _resolveRequest(request, _notFound);
     } else {
         request.response.close();
     }
  }

  bool checkSecurity(HttpRequest req, List<String> roles) {
    if (roles != null) {
      return securityContext.checkAuthorization(req, roles);
    } else {
      return true;
    }
  }

  void _resolveRequest(HttpRequest req, ControllerHandler controllerHandler) {
    Model model = new Model();
    ForceRequest forceRequest = new ForceRequest(req);
    
    // check locale 
    forceRequest.locale = localeResolver.resolveLocale(forceRequest);
    
    var result;
    
    try {
      interceptors.preHandle(forceRequest, model, this);
      result = controllerHandler(forceRequest, model);
      interceptors.postHandle(forceRequest, model, this);
    } catch (e) {
      // do proper exception handling 
      if (e is Exception) {
        result = exceptionResolver.resolveException(forceRequest, model, e);
      } else if (e is Error) {
        result = exceptionResolver.resolveError(forceRequest, model, e);
      }
    }
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
      req.response.redirect(location, status: HttpStatus.MOVED_TEMPORARILY);
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
    responseHooks.forEach((ResponseHook responseHook) {
      responseHook(response);
    });
    response
      ..headers.contentType = contentType
      ..write(result)
        ..close();
  }
   
  /**
   * This requestHandler can be used to hook into the system without having to start a server.
   * You need to use this method for example with Google App Engine runtime.
   * 
   * @param request is the current HttpRequest that needs to be handled by the system.
   * @param optional parameter to handle webSockets
   */
  void requestHandler(HttpRequest request, [WebSocketHandler handleWs]) {
    if (requestStreamer==null) {
      // initialize all
      requestStreamer = new HttpRequestStreamer();
      _onStartComplete(requestStreamer.stream, handleWs);
    }
    this.requestStreamer.add(request);
  }

  void _onStart(Stream<HttpRequest> incoming, [WebSocketHandler handleWs]) {
    log.info("Web server is running on "
        "'http://${Platform.localHostname}:$port/'");
    _scanning();
    router = new Router(incoming);

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
    viewRender = new MustacheRender(servingAssistent, views, clientFiles, clientServe);
  }
  
  void set strategy(SecurityStrategy strategy) {
    securityContext.strategy = strategy;
  }
  
  void loadValues(String path) => this.registry.loadValues(path);
}

