library dart_force_mvc_lib;

import 'dart:async';
import 'dart:mirrors';
import 'dart:convert';
import 'dart:io';

import 'package:http_server/http_server.dart' as http_server;
import 'package:route/server.dart' show Router, UrlPattern;
import 'package:logging/logging.dart' show Logger, Level, LogRecord;

import 'package:mustache4dart/mustache4dart.dart';

import 'package:forcemirrors/force_mirrors.dart';
import 'package:force_it/force_it.dart';

part 'server/web_server.dart';
part 'server/simple_web_server.dart';
part 'server/force_mvc_typedefs.dart';
part 'server/force_request_method.dart';
part 'server/force_model.dart';
part 'server/force_request.dart';
part 'server/force_registry.dart';
part 'server/force_handler_interceptor.dart';
part 'server/force_interceptors_collection.dart';
part 'server/force_path_analyzer.dart';
part 'server/force_serving_files.dart';
part 'server/force_response_hooks.dart';
// security
part 'security/security_context_holder.dart';
part 'security/security_strategy.dart';
part 'security/no_security_strategy.dart';

// render
part 'render/force_view_render.dart';
part 'render/force_mustache_render.dart';

part 'annotations/force_authentication.dart';
part 'annotations/force_request_mapping.dart';
part 'annotations/force_model_attribute.dart';
part 'annotations/force_controller.dart';
part 'annotations/force_path_variable.dart';
part 'annotations/force_request_param.dart';