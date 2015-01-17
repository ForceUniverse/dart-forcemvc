part of dart_force_mvc_lib;

@Config
class WebConfig {
  
  @Bean
  SecurityContextHolder securityContextHolder() {
    return new SecurityContextHolder(new NoSecurityStrategy());
  }
  
  @Bean
  HandlerExceptionResolver exceptionResolver() {
    return new SimpleExceptionResolver();
  }
  
  @Bean
  LocaleResolver localeResolver() {
    return new AcceptHeaderLocaleResolver();
  }
  
}