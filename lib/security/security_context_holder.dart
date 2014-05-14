part of dart_force_mvc_lib;

class SecurityContextHolder {

  SecurityStrategy strategy;
  
  SecurityContextHolder(this.strategy);
  
  bool checkAuthorization(req, {data: null}) { 
    return this.strategy.checkAuthorization(req, data: data);
  }
  
  Uri redirectUri(HttpRequest req) => this.strategy.getRedirectUri(req);
}