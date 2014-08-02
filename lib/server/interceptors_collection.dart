part of dart_force_mvc_lib;

class InterceptorsCollection {
  
  List<HandlerInterceptor> interceptors = new List<HandlerInterceptor>();
  
  void add(HandlerInterceptor interceptor) {
    this.interceptors.add(interceptor);
  }
  
  void addAll(List<HandlerInterceptor> interceptors) {
    this.interceptors.addAll(interceptors);
  }
  
  void preHandle(ForceRequest req, Model model, Object handler) {
    for (HandlerInterceptor interceptor in interceptors) {
      if (!interceptor.preHandle(req, model, handler)) {
        break;
      }
    }
  }
  
  void postHandle(ForceRequest req, Model model, Object handler) {
    for (HandlerInterceptor interceptor in interceptors) {
      interceptor.postHandle(req, model, handler);
    }
  }
  
  void afterCompletion(ForceRequest req, Model model, Object handler) {
    for (HandlerInterceptor interceptor in interceptors) {
      interceptor.afterCompletion(req, model, handler);
    }
  }
  
}