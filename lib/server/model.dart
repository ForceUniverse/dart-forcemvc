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
  
  void addAttribute(String key, var value) {
      values[key] = value;
  }
  
  bool containsAttribute(String key) {
    return values.containsKey(key);
  }
  
  getData() {
    if (dynamic!=null) {
      if (values.isNotEmpty) {
        List dataList = new List(); 
        dataList.add(dynamic);
        dataList.add(values);
        return dataList;
      }
      return dynamic;
    } else {
      return values;
    }
  }
}