part of example_forcedart;

@Controller
class PathController {
  
  @RequestMapping(value: "/var/{var1}/")
  String variable(req, Model model, var1) {
    model.addAttribute("variable", var1);
    return "pathvar";
  }
  
  @RequestMapping(value: "/path/{var1}/")
  String multivariable(req, Model model, @PathVariable("var1") variable) {
      model.addAttribute("variable", variable);
      return "pathvar";
  }

  @RequestMapping(value: "/qs/")
  String querystring(req, Model model, @RequestParam(value:"var", defaultValue: "what?") variable) {
      model.addAttribute("variable", variable);
      return "requestparam";
  }
}