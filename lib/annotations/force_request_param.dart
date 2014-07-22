part of dart_force_mvc_lib;

/**
 * Annotation which indicates that a method parameter should be bound to a web
 * request parameter.
 * */

class RequestParam {
  
  final String value;
  final String defaultValue;
  const RequestParam({this.value: "", this.defaultValue: ""});

  String toString() => "$value -> - $defaultValue";
  
}