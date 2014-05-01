part of dart_force_mvc_lib;

abstract class ForceViewRender {
  final Logger log = new Logger('ForceViewRender');
  String views;
  String clientFiles;
  bool clientServe;
  
  ForceViewRender([this.views, this.clientFiles, this.clientServe]) {
    // Check so that we have a server side views directory exists  
    views = Platform.script.resolve(views).toFilePath();
    
    if (!new Directory(views).existsSync()) {
      log.severe("The 'views/' directory was not found.");
    }
    
    // If we should serve client files, check that pub build has been run
    if(clientServe == true) {
      clientFiles = Platform.script.resolve(clientFiles).toFilePath();
            
      if (!new Directory(clientFiles).existsSync()) {
              log.severe("The 'build' directory was not found ($clientFiles). Please run 'pub build'.");
              return;
            }
    }
  }
  
  Future<String> render(String view, model) {
    Completer<String> completer = new Completer<String>();
    var viewUri = new Uri.file(views).resolve("$view.html");
    var file = new File(viewUri.toFilePath());
    
    if (file.existsSync()) {
      _readFile(file, completer, model);
    } else {
      viewUri = new Uri.file(clientFiles).resolve("$view.html");
      file = new File(viewUri.toFilePath());
      if (file.existsSync()) {
        _readFile(file, completer, model);
      } else {
        completer.complete("");
      }
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

