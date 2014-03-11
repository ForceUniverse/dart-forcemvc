part of dart_force_mvc_lib;

class RequestParam {
  
  final String value;
  final String defaultvalue;
  const RequestParam({this.value: "", this.defaultvalue: ""});

  String toString() => "$value -> - $defaultvalue";
  
}