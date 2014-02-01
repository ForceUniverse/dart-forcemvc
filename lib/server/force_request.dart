part of dart_force_mvc_lib;

class ForceRequest {
  
  HttpRequest request;
  
  ForceRequest(this.request);
  
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