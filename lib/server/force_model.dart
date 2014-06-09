part of dart_force_mvc_lib;

class Model {
  
  final Logger log = new Logger('Model');
  
  var dynamic;
  // Changed from Map<String,String> into generic,
  // You can add other types of object without limitation
  Map values = new Map();
  
  void addAttributeObject(dynamic) {
    this.dynamic = dynamic;
  }
  
  void addAttribute(String key, String value) {
      values[key] = value;
    }
  
  /**
   * With this you can add object into your models
   **/
  void addAttributeObj(String key, var genericOBJ) {
      values[key] = genericOBJ;
  }
  
  bool containsAttribute(String key) {
    return values.containsKey(key);
  }
  
  getData() {
    if (dynamic!=null) {
      return dynamic;
    } else {
      return values;
    }
  }
}