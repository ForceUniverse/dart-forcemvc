part of example_forcedart;

class SessionStrategy extends SecurityStrategy {
  
  bool checkAuthorization(HttpRequest req, List<String> roles, data) {
    HttpSession session = req.session;
    return (session["role"]!=null && roles.any((r) => r == session["role"]));
  }   
  
  Uri getRedirectUri(HttpRequest req) {
    var referer = req.uri.toString();
    return Uri.parse("/login/?referer=$referer");
  }
}