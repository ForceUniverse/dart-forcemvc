part of example_forcedart;

@ControllerAdvice
class TextAdvice {
  
  @ModelAttribute("text")
  String addText() {
    return "just some text";
  }
  
  @ExceptionHandler()
  String errorPage() {
    return "error";
  }
  
}