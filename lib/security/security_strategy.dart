part of dart_force_mvc_lib;

abstract class SecurityStrategy<T> {

  bool checkAuthorization(T req, {data: null});
  
  Uri getRedirectUri(HttpRequest req);
  
}