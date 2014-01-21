part of dart_force_mvc_lib;

class Model {
  
  final Logger log = new Logger('Model');
  
  var dynamic;
  Map<String, String> values = new Map<String, String>();
  
  void addAttributeObject(dynamic) {
    this.dynamic = dynamic;
  }
  
  void addAttribute(String key, String value) {
    values[key] = value;
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