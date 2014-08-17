part of dart_force_mvc_lib;

class MVCAnnotationHelper {
  static bool hasAuthentication(Object obj) {
    AnnotationChecker<_Authentication> annoChecker = new AnnotationChecker<_Authentication>();
    return annoChecker.hasOnClazz(obj);
  }
}