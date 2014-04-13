part of dart_force_mvc_lib;

class NoSecurityStrategy extends SecurityStrategy {
  
  bool checkAuthorization() => true;   
  
}