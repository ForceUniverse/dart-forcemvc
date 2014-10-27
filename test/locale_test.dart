import 'package:unittest/unittest.dart';
import 'package:forcemvc/force_mvc.dart';

main() {  
  // First tests!  
  var locale = Locale.ENGLISH;
  
  test('test basic locale', () {
      expect(locale.toString(), "en");
  });
  
}