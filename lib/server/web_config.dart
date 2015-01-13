part of dart_force_mvc_lib;

@Config
class WebConfig {
  
  @Bean
  SecurityContextHolder securityContextHolder() {
    return new SecurityContextHolder(new NoSecurityStrategy());
  }
  
}