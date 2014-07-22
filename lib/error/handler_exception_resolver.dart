part of dart_force_mvc_lib;

/**
 * Abstract class to be implemented by objects than can resolve exceptions thrown
 * during handler mapping or execution, in the typical case to error views.
 *
 */

abstract class HandlerExceptionResolver {
  
    /**
     * Try to resolve the given exception that got thrown during on handler execution,
     * returning a String that represents a specific error page if appropriate.
     * @param request current Force Request, an encapsulated HttpRequest
     * @param ex the exception that got thrown during handler execution
     * @return a corresponding String that represents the viewname of your template
     */
  String resolveException(ForceRequest request, Model model, Exception ex);
  
}