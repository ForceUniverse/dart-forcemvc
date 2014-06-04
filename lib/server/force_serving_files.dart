part of dart_force_mvc_lib;

class ServingFiles {
  final Logger log = new Logger('ServingFiles');
  Router router;
  var virDir;
  String startPage = 'index.html';
  
  void _serveClient(clientFiles, clientServe) {
    if(clientServe == true) {
      // Set up default handler. This will serve files from our 'build' directory.
      virDir = new http_server.VirtualDirectory(clientFiles); 
      
      // Disable jail-root, as packages are local sym-links.
      virDir..jailRoot = false
            ..allowDirectoryListing = true;
      
      virDir.directoryHandler = (dir, request) {
        // Redirect directory-requests to index.html files.
        var indexUri = Platform.script.resolve(dir.path).resolve(startPage);
        log.info("We serve $indexUri from the webserver!");
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
      
      // Start serving dart files
      String dartFiles = clientFiles;
      // dartFiles = dartFiles.replaceAll("/build", "");
      _serveDartFiles(dartFiles);
        
      // Start serving static files 
      _serveStaticFiles(clientFiles);
    }
  }
  
  void serveFile(String fileName, HttpRequest request) {
    Uri fileUri = Platform.script.resolve(fileName);
    virDir.serveFile(new File(fileUri.toFilePath()), request);
  }
  
  void _serveDartFiles(clientFiles) {
    var pattern = new UrlPattern(r'([/|.|\w|\s])*\.(?:dart)');

    router.serve(pattern).listen((request) {
      var path = request.uri.path;
      serveFile("${clientFiles}${path}", request);
    });
  }
  
  void _serveStaticFiles(clientFiles) {
    var pattern = new UrlPattern('/static/([/|.|\\-|\\w|\\s])*');
    
    router.serve(pattern).listen((request) {
      var path = request.uri.path;
      serveFile("${clientFiles}${path}", request);
    });
  }
}

