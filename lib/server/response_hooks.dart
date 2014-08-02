part of dart_force_mvc_lib;

response_hook_cors(HttpResponse response) {
  response
          ..headers.add("Access-Control-Allow-Origin", "*, ")
          ..headers.add("Access-Control-Allow-Methods", "POST, GET, OPTIONS")
          ..headers.add("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");
}