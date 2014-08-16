part of dart_force_mvc_lib;

class SecurityContextHolder {

  SecurityStrategy strategy;
  
  SecurityContextHolder(this.strategy);
  
  bool checkAuthorization(HttpRequest req, List<String> roles, {data: null}) {
    return this.strategy.checkAuthorization(req, roles, data);
  }
  
  Uri redirectUri(HttpRequest req) => this.strategy.getRedirectUri(req);
}