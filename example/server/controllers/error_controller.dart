part of example_forcedart;

class DoorLockedError extends StateError {
  DoorLockedError(String msg) : super(msg);
}

@Controller
class ErrorController {
  
  @RequestMapping(value: "/error/thrown/door/")
  String doorlocked(req, Model model) {
    throw new DoorLockedError("something is looked!");
  }
  
  @RequestMapping(value: "/error/thrown/all/")
  String error(req, Model model) {
      throw new Error();
  }
  
  @ExceptionHandler(type: DoorLockedError)
  String doorLockedError(req, Model model) {
    model.addAttribute("explanation", "This is a specific error!");
    return "error";  
  }
  
  @ExceptionHandler()
  String error_catch(req, Model model) {
      model.addAttribute("explanation", "Some error!");
      return "error";  
  }
}