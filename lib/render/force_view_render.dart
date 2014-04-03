part of dart_force_mvc_lib;

abstract class ForceViewRender {

  final Logger log = new Logger('ForceViewRender');
  String viewDir;
  String buildDir;
  
  ForceViewRender() {
    viewDir = Platform.script.resolve("../views/").toFilePath();
    if (!new Directory(viewDir).existsSync()) {
      log.severe("The 'views/' directory was not found.");
    }
    buildDir = Platform.script.resolve("../build/").toFilePath();
    if (!new Directory(buildDir).existsSync()) {
        log.severe("The 'build/' directory was not found. Please create a directory in your project with the name 'views'.");
    }
  }
  
  Future<String> render(String view, model) {
    Completer<String> completer = new Completer<String>();
    
    var viewUri = new Uri.file(viewDir).resolve("$view.html");
    var file = new File(viewUri.toFilePath());
    if (file.existsSync()) {
      _readFile(file, completer, model);
    } else {
      viewUri = new Uri.file(buildDir).resolve("$view.html");
      file = new File(viewUri.toFilePath());
      if (file.existsSync()) {
        _readFile(file, completer, model);
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