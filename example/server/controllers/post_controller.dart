part of example_forcedart;

@Controller
class PostController {

  @RequestMapping(value: "/form/")
  String form(req, Model model) {
    return "form";
  }

  @RequestMapping(value: "/post/", method: "POST")
  Future countMethod(req, Model model) async {
     var map = await req.getPostParams();
     model.addAttribute("email", map["email"]);
     model.addAttribute("status", "ok");

     return map;
  }

}
