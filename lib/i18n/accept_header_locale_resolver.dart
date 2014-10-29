part of dart_force_mvc_lib;

/**
 * Implementation of LocaleResolver that simply uses the primary locale
 * specified in the "accept-language" header of the HTTP request (that is,
 * the locale sent by the client browser, normally that of the client's OS).
 */
class AcceptHeaderLocaleResolver implements LocaleResolver {

  final regex = new RegExp(r'([a-z]{1,8}(-[a-z]{1,8})?)s*(;s*qs*=s*(1|0.[0-9]+))');
  
  Locale resolveLocale(ForceRequest request) {
    Locale locale;
    
    // request.header(name)
    
    return locale;
  }

  void setLocale(ForceRequest request, Locale locale) {
    throw new UnsupportedError(
        "Cannot change HTTP accept header - use a different locale resolution strategy");
  }
  
  Locale resolveLocaleWithHeader(String accept_header) {
    List<Locale> locales = new List<Locale>();
    for (String str in accept_header.split(",")){
        List arr = str.trim().replaceAll("-", "_").split(";");

      //Parse the locale
        Locale locale = null;
        List l = arr[0].split("_");
        switch(l.length){
            case 2: locale = new Locale(l[0], l[1]); break;
            case 3: locale = new Locale(l[0], l[1], variant: l[2]); break;
            default: locale = new Locale(l[0], ""); break;
        }

      //Parse the q-value
        double q = 1.0;
        for (String s in arr){
            s = s.trim();
            if (s.startsWith("q=")){
                q = double.parse(s.substring(2).trim());
                break;
            }
        }

      //Print the Locale and associated q-value
        print(locale);
        locales.add(locale);
    }
    return locales.isNotEmpty? locales[0] : null; 
  }
}
