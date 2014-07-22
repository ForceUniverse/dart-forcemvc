part of dart_force_mvc_lib;

/**
 * A simple dummy implementation for the handling of a exception
 */

class SimpleExceptionResolver extends HandlerExceptionResolver {
  
  static final String DEFAULT_EXCEPTION_ATTRIBUTE = "exception";
  
    /**
     * A simple implementation of the given exception that got thrown during on handler execution.
     * @param request current Force Request, an encapsulated HttpRequest
     * @param ex the exception that got thrown during handler execution
     * @return a corresponding String that represents the viewname of your template or null when a json response is required
     */
  String resolveException(ForceRequest request, Model model, Exception ex) {
    model.addAttribute(DEFAULT_EXCEPTION_ATTRIBUTE, ex);
    return null;
  }
  
}