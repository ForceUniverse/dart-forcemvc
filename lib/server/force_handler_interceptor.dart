part of dart_force_mvc_lib;

class HandlerInterceptor {
  
  bool preHandle(ForceRequest req, Model model, Object handler) => true;
  
  void postHandle(ForceRequest req, Model model, Object handler) {}
  
  void afterCompletion(ForceRequest req, Model model, Object handler) {}
  
}