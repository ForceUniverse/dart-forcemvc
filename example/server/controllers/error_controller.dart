part of example_forcedart;

class DoorLockedError extends StateError {
  DoorLockedError(String msg) : super(msg);
}

@Controller
class ErrorController {
  
  @RequestMapping(value: "/error/thrown/door/")
  String doorlocked(req, Model model, var1) {
    throw new DoorLockedError("something is looked!");
  }
  
  @RequestMapping(value: "/error/thrown/all/")
  String error(req, Model model, var1) {
      throw new Error();
  }
  
  @ExceptionHandler(type: DoorLockedError)
  String capture(req, Model model) {
    return "error";  
  }
  
}