part of dart_force_mvc_lib;

abstract class ForceViewRender {

  final Logger log = new Logger('ForceViewRender');
  String viewDir;
  
  ForceViewRender() {
    viewDir = Platform.script.resolve("../views/").toFilePath();
    if (!new Directory(viewDir).existsSync()) {
      log.severe("The 'view/' directory was not found. Please create a directory in your project with the name 'view'.");
    }
  }
  
  Future<String> render(String view, model) {
    Completer<String> completer = new Completer<String>();
    
    var viewUri = new Uri.file(viewDir).resolve("$view.html");
    var file = new File(viewUri.toFilePath());
    file.readAsBytes().then((data) {
      var template = new String.fromCharCodes(data);
      
      var result = _render_impl(template, model);
      
      completer.complete(result);
    });
    return completer.future;
  }
  
  String _render_impl(String template, model);
  
}