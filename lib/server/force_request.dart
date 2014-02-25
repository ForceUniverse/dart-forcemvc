part of dart_force_mvc_lib;

class ForceRequest {
  
  HttpRequest request;
  Map<String, String> path_variables;
  
  ForceRequest(this.request) {
    path_variables = new Map<String, String>(); 
  }
  
  Future<dynamic> postData() {
    Completer<dynamic> completer = new Completer<dynamic>();
    this.request.listen((List<int> buffer) {
      // Return the data back to the client.
      String dataOnAString = new String.fromCharCodes(buffer);
      print(dataOnAString);
      
      var package = JSON.decode(dataOnAString);
      completer.complete(package);
    });
    return completer.future;
  }
  
}