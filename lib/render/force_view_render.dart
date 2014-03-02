part of dart_force_mvc_lib;

abstract class ForceViewRender {

  Future<String> render(String view, model) {
    Completer<String> completer = new Completer<String>();
    var viewDir = Platform.script.resolve("../views/").toFilePath();
    if (!new Directory(viewDir).existsSync()) {
          //log.severe("The 'build/' directory was not found. Please run 'pub build'.");
    }
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