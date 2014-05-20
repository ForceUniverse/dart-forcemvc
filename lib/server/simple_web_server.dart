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
 
  _onStart(server, [WebSocketHandler handleWs]) {}
}

