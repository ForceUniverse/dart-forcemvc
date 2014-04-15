part of dart_force_mvc_lib;

class SecurityContextHolder {

  SecurityStrategy strategy;
  
  SecurityContextHolder(this.strategy);
  
  bool checkAuthorization(HttpRequest req) { 
    return this.strategy.checkAuthorization(req);
  }
  
  Uri get redirectUri => this.strategy.getRedirectUri();
}