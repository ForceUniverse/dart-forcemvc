part of dart_force_mvc_lib;

class ServingFiles {
  
  Router router;
  var virDir;
  var staticDir = 'static';
  
  void serveFile(String fileName, HttpRequest request) {
      Uri fileUri = Platform.script.resolve(fileName);
      virDir.serveFile(new File(fileUri.toFilePath()), request);
  }
  
  void _dartFilesServing() {
      var pattern = new UrlPattern(r'([/|.|\w|\s])*\.(?:dart)');
      router.serve(pattern).listen((request) {
        var path = request.uri.path;
        
        serveFile("../web/$path", request);
      });
    }
    
    void _staticFilesServing() {
        var pattern = new UrlPattern('/$staticDir/([/|.|\\-|_|\\w|\\s])*');
        router.serve(pattern).listen((request) {
          var path = request.uri.path;
          
          serveFile("../$path", request);
        });
    }
}