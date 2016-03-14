part of example_forcedart;

@Controller
class StatusController {

  @RequestMapping(value: "/status/404")
  @ResponseStatus(HttpStatus.NOT_FOUND)
  void form(req, Model model) {
    model.addAttribute("status", "404 not found");
  }

}
