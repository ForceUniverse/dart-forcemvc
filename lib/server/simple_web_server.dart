part of dart_force_mvc_lib;

class SimpleWebServer {
  final Logger log = new Logger('SimpleServer');
  
  Router router;
  
  var host;
  var port;
  var wsPath;
  var clientFiles;
  var clientServe;
  var virDir;
  var bind_address = InternetAddress.ANY_IP_V6;
  
  Completer _completer = new Completer.sync();

  SimpleWebServer(this.host,    
                  this.port,
                  this.wsPath,
                  this.clientFiles,
                  this.clientServe) {
    init();
  }
  
  void init() {
    if (host != null) {
      this.bind_address = host;
    }
    
    // If we should serve client files, check that pub build has been run
    if(clientServe == true) {
      // Build dir of running server script 
      var pathLen = Platform.script.pathSegments.length;
      var buildDir = Platform.script.pathSegments.sublist(0, pathLen - 1).join("/");
      buildDir = "${buildDir}/build";
      try {
        if (!new Directory(buildDir).existsSync()) {
          log.severe("The 'build' directory was not found ($buildDir). Please run 'pub build'.");
          return;
        }
      } on FileSystemException {
        log.severe("The 'build' directory was not found ($buildDir). Please run 'pub build'.");
      }
    }
  }
  
  Future start([WebSocketHandler handleWs]) {
    HttpServer.bind(bind_address, port).then((server) { 
      _onStart(server, handleWs);
      _completer.complete(const []);
    });
    
    return _completer.future;
  }

  Stream<HttpRequest> serve(String name) {
    return router.serve(name);
  }
 
  _onStart(server, [WebSocketHandler handleWs]) {}
}

