part of dart_force_mvc_lib;

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