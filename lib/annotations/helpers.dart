part of dart_force_mvc_lib;

class MVCAnnotationHelper {
  static bool hasAuthentication(Object obj) {
    AnnotationScanner<_Authentication> annoChecker = new AnnotationScanner<_Authentication>();
    return annoChecker.isOn(obj);
  }
}