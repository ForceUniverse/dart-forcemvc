part of dart_force_mvc_lib;

class NoSecurityStrategy extends SecurityStrategy<dynamic> {
  
  bool checkAuthorization(obj) => true;   
  
  Uri getRedirectUri(HttpRequest req) {
    return Uri.parse("/");
  }
}