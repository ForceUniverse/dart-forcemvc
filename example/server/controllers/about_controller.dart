part of example_forcedart;


@controller
class AboutController {
  
  @Value("name")
  String name;
  
  @Value("description")
  String description;
  
  @RequestMapping(value: "/test/about/")
  String aboutPage(req, Model model) {
    model.addAttribute("name", name);
    model.addAttribute("description", description);
    return "about";
  }
  
}