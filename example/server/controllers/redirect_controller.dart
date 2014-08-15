part of example_forcedart;

@Controller
@RequestMapping(value: "/redirect")
class RedirectController {
  
  int redirect = 0;
  
  @RequestMapping(value: "/start")
  String variable(req, Model model) {
    redirect++;
    return "redirect:/redirect/viewable/";
  }
  
  @RequestMapping(value: "/viewable/")
  String countMethod(req, Model model) {
     model.addAttribute("number", "$redirect");
     model.addAttribute("name", "redirect");
     return "number";
  }
  
}