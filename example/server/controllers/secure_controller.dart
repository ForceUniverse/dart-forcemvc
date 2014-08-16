part of example_forcedart;

class User {
  int id;
  String name;
  String role;
  String password;
}

bool hasAdminRole(User user, methodArguments) => user.role == "ADMIN";

@Controller
@PreAuthorizeRoles(const ["ADMIN"])
@PreAuthorizeIf(hasAdminRole) // Not yet implemented
class AdminController {
  
  int redirect = 0;
  
  @RequestMapping(value: "/admin/info/")
  String variable(req, Model model) {
    return "info";
  }
  
}