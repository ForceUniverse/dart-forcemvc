part of dart_force_mvc_lib;

/**
 * Annotation that will be used when the methods of the class needing authentication
 *
 */
const Authentication = const _Authentication();

class _Authentication {

  const _Authentication();

  List<String> get roles => ["BASIC"];
}

class PreAuthorizeRoles {
  final List<String> roles;

  const PreAuthorizeRoles(this.roles);
}

typedef bool PreAuthorizeFunc(user, [List methodArguments]);

class PreAuthorizeIf {
  final PreAuthorizeFunc preAuthorizeFunc;

  const PreAuthorizeIf(this.preAuthorizeFunc);
}

/**
 * Annotation that will be used to indicate that a class is a controller
 *
 */
const Controller = const _Controller();

class _Controller {

  const _Controller();

}

/**
 * Annotation that will be used to indicate that a class is a controller
 * and all methods have ResponseBody annotation
 *
 */
const RestController = const _RestController();

class _RestController {

  const _RestController();

}

/**
 * Annotation that will be used to indicate that a class is a controller adviser
 *
 */
const ControllerAdvice = const _ControllerAdvice();

class _ControllerAdvice {

  const _ControllerAdvice();

}

/**
 * Annotation that will be used to indicate a method that will be called when an exception happens
 *
 */
class ExceptionHandler {

  final Type type;

  const ExceptionHandler({this.type});

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
 *
 * */
class RequestParam {

  final String value;
  final String defaultValue;
  final bool required;
  const RequestParam({this.value: "", this.defaultValue: "", this.required: false});

  String toString() => "$value -> - $defaultValue ($required)";

}

/**
 *
 * Annotation for assigning the status code of the http response
 *
 **/
class ResponseStatus {

  final int value;

  const ResponseStatus(this.value);

  String toString() => "Response statuscode: $value";

}

/**
 * Annotation that will be used to set the response type as a json object
 *
 */
const ResponseBody = const _ResponseBody();

class _ResponseBody {

  const _ResponseBody();

}
