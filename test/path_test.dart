import 'package:test/test.dart';
import 'package:forcemvc/force_mvc.dart';
import 'package:route/server.dart' show UrlPattern, Router;

main() {  
  // First tests!  
  var path = "/some/{var1}/path/{var2}";
  PathAnalyzer pathAnalyzer = new PathAnalyzer(path);
  
  var expression = pathAnalyzer.expression;
  
  test('test the path analyzer', () {
      expect(pathAnalyzer.variables.length, 2);
      expect(pathAnalyzer.variables.last, "var2");
      expect(pathAnalyzer.route, "/some/$expression/path/$expression");
  });
  
  PathAnalyzer path_analyzer = new PathAnalyzer("/some/{var1}");
  var route = path_analyzer.route;
  //var regex = r"/some/(\w+)";
  UrlPattern urlPattern = new UrlPattern(route);
  test('test the urlpattern of path analyzer route', () {
      expect(urlPattern.matches("/some/blablabla"), true);
  });
}