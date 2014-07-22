part of dart_force_mvc_lib;

/**
 * Annotation for mapping web requests onto specific handler classes and/or
 * handler methods. Provides a consistent style between the different
 * environments, with the semantics adapting to the concrete environment.
 * 
 * Look at the following example, how you can use this:
 * 
 * @RequestMapping(value: "/someurl", method: "GET")
 * void index(ForceRequest req, Model model)
 *
 * */

class RequestMapping {
  
  final String value;
  final String method;
  const RequestMapping({this.value: "", this.method:"GET"});

  String toString() => "$value -> $method";
  
}