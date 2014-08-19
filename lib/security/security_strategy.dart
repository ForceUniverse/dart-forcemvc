part of dart_force_mvc_lib;

abstract class SecurityStrategy<T> {

  bool checkAuthorization(T req, List<String> roles, data);
  
  Uri getRedirectUri(HttpRequest req);
  
}