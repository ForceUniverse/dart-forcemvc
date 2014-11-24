library example_forcedart;

import 'dart:io';
import 'dart:async';
import 'dart:math';
import 'package:logging/logging.dart';
import 'package:forcemvc/force_mvc.dart';
import 'package:wired/wired.dart';

part 'controllers/post_controller.dart';
part 'controllers/login_controller.dart';
part 'controllers/redirect_controller.dart';
part 'controllers/path_controller.dart';
part 'controllers/count_controller.dart';
part 'controllers/secure_controller.dart';
part 'controllers/about_controller.dart';
part 'controllers/error_controller.dart';

part 'advice/text_advice.dart';

part 'interceptors/random_interceptor.dart';
part 'controllers/security/session_strategy.dart';

void main() { 
  // Setup what port to listen to 
  var portEnv = Platform.environment['PORT'];
  var port = portEnv == null ? 8080 : int.parse(portEnv);
  var serveClient = portEnv == null ? true : false;
  
  // Create a force server 
  WebApplication webApp = new WebApplication(host: "127.0.0.1",
                                   port: port,  
                                   staticFiles: '../client/static/',
                                   clientFiles: '../client/build/web/',
                                   clientServe: serveClient,
                                   views: "views/");
  // register yaml files
  webApp.loadValues("../app.yaml");
//  server.loadValues("pubspec.yaml");
  webApp.notFound((ForceRequest req, Model model) {
    return "notfound";
  });
  
  // Set up logger.
  webApp.setupConsoleLog(Level.FINEST);
  
  // Setup session strategy
  webApp.strategy = new SessionStrategy();
  
  // Serve the view called index as default 
  webApp.use("/", (req, model) => "index");
  
  // Start serving force with a randomPortFallback 
  webApp.start(fallback: randomPortFallback);
}

