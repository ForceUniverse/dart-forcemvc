part of dart_force_mvc_lib;

class RequestParam {
  
  final String value;
  final String defaultValue;
  const RequestParam({this.value: "", this.defaultValue: ""});

  String toString() => "$value -> - $defaultValue";
  
}