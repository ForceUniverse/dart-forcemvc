part of dart_force_mvc_lib;

abstract class ForceViewRender {
  final Logger log = new Logger('ForceViewRender');
  String views;
  String clientFiles;
  bool clientServe;
  
  ServingAssistent servingAssistent;
  
  ForceViewRender(this.servingAssistent, [this.views, this.clientFiles, this.clientServe]) {
    // Check so that we have a server side views directory exists  
    views = Platform.script.resolve(views).toFilePath();
    
    _exists(views);
    
    // If we should serve client files, check that pub build has been run
    // or use the pub serve tric 
    if(clientServe == true) {
      clientFiles = Platform.script.resolve(clientFiles).toFilePath();
            
      _exists(clientFiles);
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
  
  Future<String> render(String view, model) {
    Completer<String> completer = new Completer<String>();
    var viewUri = new Uri.file(views).resolve("$view.html");
    var file = new File(viewUri.toFilePath());
    
    if (file.existsSync()) {
      _readFile(file, completer, model);
    } else {
//      viewUri = new Uri.file(clientFiles).resolve("$view.html");
//      file = new File(viewUri.toFilePath());
//      if (file.existsSync()) {
//        _readFile(file, completer, model);
//      } else {
//        completer.complete("");
//      }
      servingAssistent.read(clientFiles, "$view.html").then((Stream<List<int>> inputStream) {
        inputStream
          .transform(UTF8.decoder).listen((template) {
             var result = _render_impl(template, model);       
             completer.complete(result);
        });
      });
    }
    
    return completer.future;
  }
  
  void _readFile(File file, Completer<String> completer, model) {
    file.readAsBytes().then((data) {
      var template = new String.fromCharCodes(data);
      var result = _render_impl(template, model);
          
      completer.complete(result);
    });
  }
  
  String _render_impl(String template, model);
}

