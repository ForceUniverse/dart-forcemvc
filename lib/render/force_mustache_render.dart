part of dart_force_mvc_lib;

class MustacheRender extends ForceViewRender {

  Delimiter delimiter = new Delimiter('{{', '}}');
  
  String _render_impl(String template, model) {
      var output = render(template, model, delimiter: delimiter);
      return output; 
  }
  
}