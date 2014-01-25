part of dart_force_mvc_lib;

abstract class ForceViewRender {

  Future<String> render(String view, model) {
    Completer<String> completer = new Completer<String>();
    var file = new File("../views/$view.html");
    file.readAsBytes().then((data) {
      var template = new String.fromCharCodes(data);
      
      var result = render(template, model);
      
      completer.complete(result);
    });
    return completer.future;
  }
  
  String _render_impl(String template, model);
  
}