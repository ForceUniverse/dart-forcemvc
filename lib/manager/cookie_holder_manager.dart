part of dart_force_mvc_lib;

class CookieHolderManager {
  
  static final Logger logger = new Logger('CookieManager');
  
  /**
   * Default path that cookies will be visible to: "/", i.e. the entire server.
   */
  static final String DEFAULT_COOKIE_PATH = "/";
  
  String cookiePath = DEFAULT_COOKIE_PATH;
  
  int cookieMaxAge;
  bool cookieSecure;
  String cookieName;
  String cookieDomain;
  
  
  /**
   * Add a cookie with the given value to the response,
   * using the cookie descriptor settings of this generator.
   * 
   * Delegates to createCookie for cookie creation.
   * @param response the HTTP response to add the cookie to
   * @param cookieValue the value of the cookie to add
   */
  void addCookie(HttpResponse response, String cookieValue) {
    Cookie cookie = createCookie(cookieValue);
    int maxAge = cookieMaxAge;
    if (maxAge != null) {
      cookie.maxAge = maxAge;
    }
    if (cookieSecure) {
      cookie.secure = true;
    }
    response.cookies.add(cookie);
    logger.log(Level.INFO, "Added cookie with name [${cookieName}] and value [${cookieValue}]");
  }

  /**
   * Remove the cookie that this generator describes from the response.
   * Will generate a cookie with empty value and max age 0.
   * 
   * Delegates to createCookie for cookie creation.
   * @param response the HTTP response to remove the cookie from
   */
  void removeCookie(HttpResponse response) {
    Cookie cookie = createCookie("");
    cookie.maxAge = 0;
    response.cookies.add(cookie);
    logger.log(Level.INFO, "Removed cookie with name [${cookieName}]");
  }

  /**
   * Create a cookie with the given value, using the cookie descriptor
   * settings of this manager (except for "cookieMaxAge").
   * 
   * @param cookieValue the value of the cookie to crate
   * @return the cookie
   */
  Cookie createCookie(String cookieValue) {
    Cookie cookie = new Cookie(cookieName, cookieValue);
    if (cookieDomain != null) {
      cookie.domain = cookieDomain;
    }
    cookie.path = cookiePath;
    return cookie;
  }
  
  /**
   * Getting the cookie according to the request and the cookie name.
   * 
   * @param request the HTTP request to retrieve the cookie from
   * @return the cookie
   */
  Cookie getCookie(HttpRequest request) {
      List<Cookie> cookies = request.cookies;

      if (cookies != null) {
        for (Cookie cookie in cookies) {
          if (cookieName == cookie.name) {
            return cookie;
          }
        }
      }
      return null;
    }
}