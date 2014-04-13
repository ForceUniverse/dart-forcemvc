part of dart_force_mvc_lib;

class SecurityContextHolder {

  SecurityStrategy strategy;
  
  SecurityContextHolder(this.strategy);
  
  bool checkAuthorization() { 
    this.strategy.checkAuthorization();
  }
  
}