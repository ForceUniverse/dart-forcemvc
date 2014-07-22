part of dart_force_mvc_lib;

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