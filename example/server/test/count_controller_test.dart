import 'package:unittest/unittest.dart';
import 'package:forcemvc/force_mvc.dart';
import 'package:forcemvc/test.dart';
import '../server.dart';

main() {  
  // First tests!  
  var countController = new CountController();
  
  Model model = new Model();
  MockForceRequest req = new MockForceRequest();
  
  test('testing the count controller', () {
      var view = countController.countMethod(req, model);
      expect(view, "count");
      expect(model.getData()["count"], "2");
  });
  
 
}
