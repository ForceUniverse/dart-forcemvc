part of dart_force_mvc_lib;

class ServingFiles {
  final Logger log = new Logger('ServingFiles');
  
  Router router;
  
  var virDir;
  ServingAssistent servingAssistent;
  
  String startPage = 'index.html';
  
  void _serveClient(staticFiles, clientFiles, clientServe) {
    if(clientServe == true) {
      // Set up default handler. This will serve files from our 'build' directory.
      Uri clientFilesAbsoluteUri = Platform.script.resolve(clientFiles);
      virDir = new http_server.VirtualDirectory(clientFilesAbsoluteUri.toFilePath());
      
      servingAssistent = new ServingAssistent(_pubServeUrl(), virDir);
      
      // Disable jail-root, as packages are local sym-links.
      virDir..jailRoot = false
            ..allowDirectoryListing = true;
      
      virDir.directoryHandler = (dir, request) {
        var filePath = "$clientFiles$startPage";
        log.info("Try to server $filePath!");
        serveFile(request, "$clientFiles$startPage");
      };
      
      // Add an error page handler.
      virDir.errorPageHandler = (HttpRequest request) {
        _notFoundHandling(request);
      };

      // Serve everything not routed elsewhere through the virtual directory.
      virDir.serve(router.defaultStream);
      
      // Start serving dart files
      _serveDartFiles(clientFiles);
      _serveJsFiles(clientFiles);
      
      // Start serving static files 
      _serveStaticFiles(staticFiles);
    }
  }
  
  void _notFoundHandling(HttpRequest request) {
    log.warning("Resource not found ${request.uri.path}");
    request.response.statusCode = HttpStatus.NOT_FOUND;
  }
  
  void serveFile(HttpRequest request, String fileName) {
    servingAssistent.serve(request, fileName);
  }
  
  void _serveDartFiles(clientFiles) {
    var pattern = new UrlPattern(r'([/|.|\w|\s])*\.(?:dart)');

    this._serveWithPatterns(clientFiles, pattern);
  }
  
  void _serveJsFiles(clientFiles) {
    var pattern = new UrlPattern(r'([/|.|\w|\s])*\.(?:js)');
      
    this._serveWithPatterns(clientFiles, pattern);
  }
  
  void _serveWithPatterns(clientFiles, UrlPattern pattern) {
    router.serve(pattern).listen((request) {
      var path = request.uri.path;
      serveFile(request, "${clientFiles}${path}");
    });
  } 
  
  void _serveStaticFiles(clientFiles) {
    var pattern = new UrlPattern('/static/([/|.|\\-|\\w|\\s])*');
    
    router.serve(pattern).listen((request) {
      String path = request.uri.path;
      path = path.replaceAll('/static/', '');
      
      servingAssistent.serveFromFile(request, "${clientFiles}${path}");
    });
  }
  
  Uri _pubServeUrl() {
    var env = Platform.environment;
    String pubServeUrlString = env['DART_PUB_SERVE'];

    Uri pubServeUrl = pubServeUrlString != null
                        ? Uri.parse(pubServeUrlString)
                        : null;
    return pubServeUrl;
  }
}

