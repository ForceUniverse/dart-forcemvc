part of dart_force_mvc_lib;

class ErrorStartupStrategy {
  
  recover(Error e, SimpleWebServer sws) {
    log.warning("Could not startup the web server ... $e");
    log.warning("Is your port already in use?");
    return new WebApplicationStartError("Unable start with '${sws.host}' - '${sws.port}': $e");
  }
  
}