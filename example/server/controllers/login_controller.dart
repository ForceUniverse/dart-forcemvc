part of example_forcedart;

@Controller
class LoginController {
  
  @RequestMapping(value: "/login/")
  String form(req, Model model, @RequestParam(value: "referer", defaultValue: "/") var referer) {
    model.addAttribute("referer", referer);
    return "login";
  }
  
  @RequestMapping(value: "/login/", method: "POST")
  Future<String> countMethod(req, HttpSession session, Model model) {
     req.getPostParams().then((map) {
       if ( map["user"]=="admin" && map["pwd"]=="admin123" ) {
          model.addAttribute("user", map["user"]);
       
          session["user"] = "admin";
          var referer = map["referer"]; 
          req.async("redirect:$referer");
       } else {
         model.addAttribute("error", "not ok");
         model.addAttribute("referer", map["referer"]);
         req.async("login");
       }
     });
     model.addAttribute("status", "ok");
     
     return req.asyncFuture;
  }
  
}