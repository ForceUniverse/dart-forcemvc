part of example_forcedart;

@RestController
@RequestMapping(value: "/rest")
class JustARestController {
  int count = 0;

  JustARestController() {
    count = 1;
  }

  @RequestMapping(value: "/count")
  int countJson(req, Model model) {
    count++;
    return count;
  }

  @RequestMapping(value: "/map")
  Map mapJson() {
      Map map = new Map();
      map["count"] = "$count";
      map["bla"] = "hallo";
      return map;
  }

}
