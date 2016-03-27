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

  UrlPattern urlPattern = getMeUrlPattern("/some/{var1}");
  test('test the urlpattern of path analyzer route', () {
      expect(urlPattern.matches("/some/blablabla"), true);
  });

  UrlPattern urlPattern2 = getMeUrlPattern("/entities/entity/{id}");
  test('test special characters in the testing group', () {
      expect(urlPattern2.matches("/entities/entity/188575e0-d700-11e5-d18b-f130bc592bc4"), true);
  });
}

UrlPattern getMeUrlPattern(path) {
  PathAnalyzer path_analyzer = new PathAnalyzer(path);
  var route = path_analyzer.route;
  //var regex = r"/some/(\w+)";
  UrlPattern urlPattern = new UrlPattern(route);
  return urlPattern;
}
