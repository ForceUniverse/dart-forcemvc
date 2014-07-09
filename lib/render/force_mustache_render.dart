part of dart_force_mvc_lib;

class MustacheRender extends ForceViewRender {
  Delimiter delimiter = new Delimiter('{{', '}}');
  
  MustacheRender([views = "../views/", clientFiles = "../build/web/", clientServe = true]) : super(views, clientFiles, clientServe);
  
  String _render_impl(String template, model) {
    var output = render(_reviewTemplate(template), model, delimiter: delimiter);
    return _transform(output); 
  }
  
  String _reviewTemplate(String result) {
    result = result.replaceAll("${delimiter.opening}&amp;", "${delimiter.opening}&");
    return result;
  }
  
  String _transform(String result) {
    result = result.replaceAll("src=\"", "src=\"/");
    result = result.replaceAll("src=\"/http:/", "src=\"http:/");
    result = result.replaceAll("src=\"/../", "src=\"../");
    result = result.replaceAll("src='", "src='/");
    result = result.replaceAll("src='/http:/", "src='http:/");
    result = result.replaceAll("src='/../", "src='../");
    result = result.replaceAll("src='//", "src='/");
    result = result.replaceAll("src=\"//", "src=\"/");
    return result;
  }
}

