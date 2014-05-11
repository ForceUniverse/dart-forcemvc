part of dart_force_mvc_lib;

class SecurityContextHolder {

  SecurityStrategy strategy;
  
  SecurityContextHolder(this.strategy);
  
  bool checkAuthorization(req) { 
    return this.strategy.checkAuthorization(req);
  }
  
  Uri redirectUri(HttpRequest req) => this.strategy.getRedirectUri(req);
}