import 'package:unittest/unittest.dart';
import 'package:forcemvc/force_mvc.dart';

main() {  
  // First tests!  
  var path = "/some/{var1}/path/{var2}";
  PathAnalyzer pathAnalyzer = new PathAnalyzer(path);
  pathAnalyzer.analyze();
  
  var expression = pathAnalyzer.expression;
  
  test('test the path analyzer', () {
        expect(pathAnalyzer.variables.length, 2);
        expect(pathAnalyzer.variables.last, "var2");
        expect(pathAnalyzer.route, "/some/$expression/path/$expression");
  });

}