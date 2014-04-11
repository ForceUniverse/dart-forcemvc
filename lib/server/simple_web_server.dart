part of dart_force_mvc_lib;

class SimpleWebServer {
  
  final Logger log = new Logger('SimpleServer');
  
  Router router;
  
  var wsPath;
  var port;
  var buildDir;
  var virDir;
  var bind_address = InternetAddress.ANY_IP_V6;
  
  Completer _completer;
  
  WebServer({wsPath: '/ws', port: 8080, host: null, buildPath: '../build' }) {
    init(wsPath, port, host, buildPath);
  }
  
  void init(wsPath, port, host, buildPath) {
    this.port = port;
    this.wsPath = wsPath;
    this._completer = new Completer.sync();
    if (host!=null) {
      this.bind_address = host;
    }
    buildDir = Platform.script.resolve(buildPath).toFilePath();
    if (!new Directory(buildDir).existsSync()) {
      log.severe("The 'build' directory was not found ($buildDir). Please run 'pub build'.");
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

  Stream<HttpRequest> serve(String name) {
    return router.serve(name);
  }
 
  _onStart(server, [WebSocketHandler handleWs]) {}
}