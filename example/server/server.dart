library example_forcedart;

import 'dart:io';
import 'dart:async';
import 'dart:math';
import 'package:logging/logging.dart';
import 'package:forcemvc/force_mvc.dart';
import 'package:force_it/force_it.dart';

part 'controllers/post_controller.dart';
part 'controllers/login_controller.dart';
part 'controllers/redirect_controller.dart';
part 'controllers/path_controller.dart';
part 'controllers/count_controller.dart';
part 'controllers/secure_controller.dart';
part 'controllers/about_controller.dart';

part 'advice/text_advice.dart';

part 'interceptors/random_interceptor.dart';
part 'controllers/security/session_strategy.dart';

void main() { 
  // Setup what port to listen to 
  var portEnv = Platform.environment['PORT'];
  var port = portEnv == null ? 3030 : int.parse(portEnv);
  var serveClient = portEnv == null ? true : false;
  
  // Create a force server 
  WebServer server = new WebServer(host: "127.0.0.1",
                                   port: port,  
                                   staticFiles: '../client/static/',
                                   clientFiles: '../client/build/web/',
                                   clientServe: serveClient,
                                   views: "views/");
  // register yaml files
  server.loadValues("../app.yaml");
//  server.loadValues("pubspec.yaml");
  
  // Set up logger.
  server.setupConsoleLog(Level.FINEST);
  
  // Setup session strategy
  server.strategy = new SessionStrategy();
  
  // Serve the view called index as default 
  server.on("/", (req, model) => "index");
  
  // Start serving force 
  server.start();
  
//  var mirrorSystem = currentMirrorSystem();
//  mirrorSystem.isolate.rootLibrary.declarations.values
//  .where((dm) => dm is ClassMirror && dm.metadata.any((im) => im.reflectee is Controller))
//  .forEach((dm) {
//    print(dm);
////    print(dm.metadata.any((im) => im.reflectee is Controller));
//  });
}

