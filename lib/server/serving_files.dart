part of dart_force_mvc_lib;

class ServingFiles {
  final Logger log = new Logger('ServingFiles');
  
  Router router;
  
  var virDir;
  ServingAssistent servingAssistent;
  
  List staticFileTypes = ["dart", "js", "css", "png", "gif", "jpeg", "jpg", "webp", "html", "map"];
  
  void _serveClient(staticFiles, clientFiles, clientServe) {
    if(clientServe == true) {
      // Set up default handler. This will serve files from our 'build' directory.
      Uri clientFilesAbsoluteUri = Platform.script.resolve(clientFiles);
      virDir = new http_server.VirtualDirectory(clientFilesAbsoluteUri.toFilePath());
      
      servingAssistent = new ServingAssistent(_pubServeUrl(), virDir);
      
      // Disable jail-root, as packages are local sym-links.
      virDir..jailRoot = false
            ..allowDirectoryListing = true;
      
      // Add an error page handler.
      virDir.errorPageHandler = (HttpRequest request) {
          _notFoundHandling(request);
      };

      // Serve everything not routed elsewhere through the virtual directory.
      virDir.serve(router.defaultStream);
      
      // Start serving static files 
      _serveStaticFiles(staticFiles);
      
      // Start serving transformable files
      _serveTransformableFiles(clientFiles);
    }
  }
  
  void _notFoundHandling(HttpRequest request) {
    log.warning("Resource not found ${request.uri.path}");
    request.response.statusCode = HttpStatus.NOT_FOUND;
  }
  
  Future serveFile(HttpRequest request, String root, String fileName) async {
    try {
      await servingAssistent.serve(request, root, fileName);
    } catch(e) {
      print(e);
      _notFoundHandling(request);
    }
  }
  
  void _serveTransformableFiles(clientFiles) {
    for (var fileType in staticFileTypes) {
        String pats = '([/|.|\\-|\\w|\\W|\\s])*\\.(?:${fileType})';
        var pattern = new UrlPattern(pats);

        this._serveWithPatterns(clientFiles, pattern);
    }
  }
  
  
  void _serveWithPatterns(clientFiles, UrlPattern pattern) {
    router.serve(pattern).listen((request) {
        var path = request.uri.path; 
        serveFile(request, clientFiles, path);
    });
  } 
  
  void _serveStaticFiles(clientFiles) {
    var pattern = new UrlPattern('/static/([/|.|\\-|\\w|\\s])*');
    
    router.serve(pattern).listen((request) {
      String path = request.uri.path;
      path = path.replaceAll('/static/', '');
      
      servingAssistent.serveFromFile(request, "${clientFiles}${path}").catchError((e) {
          print(e);
          _notFoundHandling(request);
      });
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

