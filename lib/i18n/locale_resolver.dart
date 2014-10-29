part of dart_force_mvc_lib;

/**
 * Astract class for web-based locale resolution strategies that allows for
 * both locale resolution via the request and locale modification via
 * request and response.
 *
 * <p>This interface allows for implementations based on request, session,
 * cookies, etc. The default implementation is AcceptHeaderLocaleResolver,
 * simply using the request's locale provided by the respective HTTP header.
 *
 */
abstract class LocaleResolver {

  /**
   * Resolve the current locale via the given request.
   * Should return a default locale as fallback in any case.
   * @param request the request to resolve the locale for
   * @return the current locale (never <code>null</code>)
   */
  Locale resolveLocale(ForceRequest request);

  /**
   * Set the current locale to the given one.
   * @param request the request to be used for locale modification
   * @param locale the new locale, or <code>null</code> to clear the locale
   * @throws UnsupportedOperationException if the LocaleResolver implementation
   * does not support dynamic changing of the theme
   */
  void setLocale(ForceRequest request, Locale locale);

}
