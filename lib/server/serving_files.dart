part of dart_force_mvc_lib;

class ServingFiles {
  final Logger log = new Logger('ServingFiles');
  Router router;
  var virDir;
  String startPage = 'index.html';
  
  void _serveClient(staticFiles, clientFiles, clientServe) {
    if(clientServe == true) {
      // Set up default handler. This will serve files from our 'build' directory.
      Uri clientFilesAbsoluteUri = Platform.script.resolve(clientFiles);
      virDir = new http_server.VirtualDirectory(clientFilesAbsoluteUri.toFilePath());
      
      // Disable jail-root, as packages are local sym-links.
      virDir..jailRoot = false
            ..allowDirectoryListing = true;
      
      virDir.directoryHandler = (dir, request) {
        var filePath = "$clientFiles$startPage";
        log.info("Try to server $filePath!");
        serveFile("$clientFiles$startPage", request);
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
      _serveDartFiles(clientFiles);
        
      // Start serving static files 
      _serveStaticFiles(staticFiles);
    }
  }
  
  void serveFile(String fileName, HttpRequest request) {
    Uri fileUri = Platform.script.resolve(fileName);
    File file = new File(fileUri.toFilePath());
    if (!file.existsSync()) {
      fileName = fileName.replaceFirst("/build", "");
      fileUri = Platform.script.resolve(fileName);
      file = new File(fileUri.toFilePath());
    }
    virDir.serveFile(file, request);
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
      String path = request.uri.path;
      path = path.replaceAll('/static/', '');
      serveFile("${clientFiles}${path}", request);
    });
  }
}

