part of example_forcedart;


@RequestMapping(value: "/rest")
@RestController
class JustARestController {
  int count = 0;

  JustARestController() {
    count = 1;
  }

  @RequestMapping(value: "/count")
  @ResponseBody
  int countJson(req, Model model) {
    count++;
    return count;
  }

}
