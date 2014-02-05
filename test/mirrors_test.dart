import 'package:unittest/unittest.dart';
import 'package:forcemvc/force_mvc.dart';

main() {  
  // First tests!  
  MirrorHelpers<ModelAttribute> mirrorHelper = new MirrorHelpers<ModelAttribute>();
  List<MirrorValue<ModelAttribute>> mirrorModels = mirrorHelper.getMirrorValues(new Anno());
  
  test('basic tests for mirror helper api', () {
     expect(mirrorModels.length, 2);
     expect(mirrorModels.first.mirror.value, "test");
  });
    
}

class Anno {
  
  @ModelAttribute("test")
  void test() {}

  @ModelAttribute("test2")
  void test2() {}
  
}

