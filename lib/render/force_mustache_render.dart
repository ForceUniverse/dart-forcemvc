part of dart_force_mvc_lib;

class MustacheRender extends ForceViewRender {

  String _render_impl(String source, model) {
    var template = mustache.parse(source);
    var output = template.renderString(model);
    return output;
  }
  
}