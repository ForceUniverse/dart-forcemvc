import 'package:unittest/unittest.dart';
import 'package:forcemvc/force_mvc.dart';

main() {  
  // First tests!  
  var locale = Locale.ENGLISH;
  
  test('test basic locale', () {
      expect(locale.toString(), "en");
  });
  
  // "en", "de_DE", "_GB", "en_US_WIN", "fr__MAC"
  test('test locale parsing en', () {    
    Locale locale = Locale.parseString("en");
    expect(locale.getLanguage(), "en");
  });
  
  test('test locale parsing de_DE', () {    
      Locale locale = Locale.parseString("de_DE");
      expect(locale.getLanguage(), "de");
      expect(locale.getCountry(), "DE");
  });
  
  test('test locale parsing _GB', () {    
        Locale locale = Locale.parseString("_GB");
        expect(locale.getLanguage(), "");
        expect(locale.getCountry(), "GB");
    });
  
  test('test locale parsing en_US_WIN', () {
    Locale locale = Locale.parseString("en_US_WIN");
    expect(locale.getLanguage(), "en");
    expect(locale.getCountry(), "US");
    expect(locale.getVariant(), "WIN");
  });

  test('test locale parsing fr__MAC', () {
    Locale locale = Locale.parseString("fr__MAC");
    expect(locale.getLanguage(), "fr");
    expect(locale.getCountry(), "");
    expect(locale.getVariant(), "MAC");
  });

}