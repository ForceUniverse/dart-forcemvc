part of dart_force_mvc_lib;

/**
 * Always returns a default locale, implementation of a locale resolver
 */
class FixedLocaleResolver extends AbstractLocaleResolver {

  /**
   * Create a FixedLocaleResolver that exposes the given locale.
   * @param locale the locale to expose
   */
  FixedLocaleResolver(Locale locale) {
    setDefaultLocale(locale);
  }


  Locale resolveLocale(ForceRequest request) {
    Locale locale = getDefaultLocale();
    if (locale == null) {
      locale = Locale.defaultLocale;
    }
    return locale;
  }

  void setLocale(ForceRequest request, Locale locale) {
    throw new UnsupportedError(
        "Cannot change fixed locale - use a different locale resolution strategy");
  }

}
