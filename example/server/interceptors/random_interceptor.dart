part of example_forcedart;

class RandomInterceptor implements HandlerInterceptor {
  
  bool preHandle(ForceRequest req, Model model, Object handler) {
    print("preHandle req ...");
    return true; 
  }
  
  void postHandle(ForceRequest req, Model model, Object handler) {
    print("postHandle req ...");
    var rng = new Random();
    var rnd = rng.nextInt(100);
    model.addAttribute("random", "$rnd");
  }
  
  void afterCompletion(ForceRequest req, Model model, Object handler) {
    print("after completion ...");
  }
  
}