part of dart_force_mvc_lib;

/**
 * Annotation that will be used when the methods of the class needing authentication
 *
 */
class Authentication {
  
  const Authentication();
  
}

/**
 * Annotation that will be used to indicate that a class is a controller
 *
 */
class Controller {
  
  const Controller();

}

/**
 * Annotation that will be used to indicate a method that will be called when an exception happens
 *
 */
class ExceptionHandler {
  
  const ExceptionHandler();

}

/**
 * Annotation that will indicate that a method or a field needs to be added to the Model.
 *
 * You can use it like this
 * 
 * @ModelAttribute("someValue")
 * String someName() {
 *   return mv.getValue();
 * }
 * 
 */
class ModelAttribute {
  
  final String value;
  const ModelAttribute(this.value);

  String toString() => "$value";
  
}

/**
 * You can also use the annotation @PathVariable("name") to match the pathvariable, like below:
 * 
 * @RequestMapping(value: "/var/{var1}/", method: "GET")
 * String multivariable(req, Model model, @PathVariable("var1") variable) {}
 * 
 * */

class PathVariable {
  
  final String value;
  const PathVariable(this.value);

  String toString() => "$value";
  
}

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

