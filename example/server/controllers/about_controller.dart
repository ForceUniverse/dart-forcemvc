part of example_forcedart;

@Controller
class AboutController {

  @Value("name")
  String name;

  @Value("description")
  String description;

  @RequestMapping(value: "/test/about/")
  String aboutPage(req, Locale locale, Model model) {
    model.addAttribute("name", name);
    model.addAttribute("description", description);
    model.addAttribute("locale", locale.toString());
    return "about";
  }

}
