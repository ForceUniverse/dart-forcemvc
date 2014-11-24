part of dart_force_mvc_lib;

class SimpleWebServer {
  final Logger log = new Logger('SimpleServer');
  
  Router router;
  
  var host;
  var port;
  var wsPath;
  var staticFiles;
  var clientFiles;
  var clientServe;
  var virDir;
  var bind_address = InternetAddress.ANY_IP_V6;
  
  Completer _completer = new Completer.sync();

  SimpleWebServer(this.host,    
                  this.port,
                  this.wsPath,
                  this.staticFiles,
                  this.clientFiles,
                  this.clientServe) {
    init();
  }
  
  void init() {
    if (host != null) {
      this.bind_address = host;
    }
    
    if(clientServe == true) {
       String clientFilesPath = Platform.script.resolve(clientFiles).toFilePath();
               
       _exists(clientFilesPath);
    }
  }
     
  void _exists(dir) {
     try {
       if (!new Directory(dir).existsSync()) {
          log.severe("The '$dir' directory was not found.");
       }
     } on FileSystemException {
       log.severe("The '$dir' directory was not found.");
     }
  }
  
  /**
     * This method helps to start your webserver.
     * 
     * You can add a [WebSocketHandler].
     */
  
  Future start({WebSocketHandler handleWs: null, FallbackStart fallback}) {
    HttpServer.bind(bind_address, port).then((server) { 
      _onStartComplete(server, handleWs);
    }).catchError((e) {
      if (fallback==null) {
        var error = _errorOnStart(e);
        return new Future.error(error);
      } else {
        fallback(this, handleWs);
      }
    });
    
    return _completer.future;
  }
  
  /**
     * This method helps to start your webserver in a secure way.
     * 
     * You can add a [WebSocketHandler], certificateName,
     * 
     * The optional argument [backlog] can be used to specify the listen
     * backlog for the underlying OS listen setup. If [backlog] has the
     * value of [:0:] (the default) a reasonable value will be chosen by
     * the system.
     *
     * The certificate with nickname or distinguished name (DN) [certificateName]
     * is looked up in the certificate database, and is used as the server
     * certificate. If [requestClientCertificate] is true, the server will
     * request clients to authenticate with a client certificate. 
     */
  
  Future startSecure({WebSocketHandler handleWs: null, String certificateName, bool requestClientCertificate: false,
    int backlog: 0}) {
      HttpServer.bindSecure(bind_address, port, certificateName: certificateName,
          requestClientCertificate: requestClientCertificate,
          backlog: backlog).then((server) { 
        _onStartComplete(server, handleWs);
      }).catchError((e) {
        var error = _errorOnStart(e);
        return new Future.error(error);
      });
      
      return _completer.future;
    }
  
  void _onStartComplete(Stream<HttpRequest> incoming, [WebSocketHandler handleWs]) {
    _onStart(incoming, handleWs);
    _completer.complete(const []);
  }
  
  Error _errorOnStart(e) {
    log.warning("Could not startup the web server ... $e");
    log.warning("Is your port already in use?");
    return new WebApplicationStartError("Unable to start with '${host}' - '${port}': $e");
  }

  Stream<HttpRequest> serve(String name) {
    return router.serve(name);
  }
  
  void setupConsoleLog([Level level = Level.INFO]) {
      Logger.root.level = level;
      Logger.root.onRecord.listen((LogRecord rec) {
        if (rec.level >= Level.SEVERE) {
          var stack = rec.stackTrace != null ? rec.stackTrace : "";
          print('${rec.level.name}: ${rec.time}: ${rec.message} - ${rec.error} $stack');
        } else {
          print('${rec.level.name}: ${rec.time}: ${rec.message}');
        }
      });
  }
 
  _onStart(Stream<HttpRequest> incoming, [WebSocketHandler handleWs]) {}
}

class WebApplicationStartError extends Error {
    final message;

    /** The [message] describes the erroneous argument. */
    WebApplicationStartError([this.message]);

    String toString() {
      if (message != null) {
        return "WebApplication start error: $message";
      }
      return "WebApplication start error";
    }
}

/*
 * This is been used in the restartFallback
 */
typedef FallbackStart(SimpleWebServer sws, WebSocketHandler wsHandler);

var randomPortFallback = (SimpleWebServer sws, WebSocketHandler wsHandler) {
  var rng = new Random();
  var newPortNumber = rng.nextInt(8888) + 1000;
  
  sws.port = newPortNumber;
  sws.start(handleWs: wsHandler);
};