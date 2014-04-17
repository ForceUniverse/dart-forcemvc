part of dart_force_mvc_lib;

class NoSecurityStrategy extends SecurityStrategy {
  
  bool checkAuthorization(HttpRequest req) => true;   
  
  Uri getRedirectUri(HttpRequest req) {
    return Uri.parse("/");
  }
}