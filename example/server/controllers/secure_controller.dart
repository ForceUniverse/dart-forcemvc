part of example_forcedart;

class User {
  int id;
  String name;
  String role;
  String password;
}

bool hasAdminRole(User user, returnObject, arguments) => user.role == "ADMIN";

@controller
@PreAuthorizeRoles(const ["ADMIN"])
//@PreAuthorizeIf(hasAdminRole)
class AdminController {
  
  int redirect = 0;
  
  @RequestMapping(value: "/admin/info/")
  String variable(req, Model model) {
    return "info";
  }
  
}