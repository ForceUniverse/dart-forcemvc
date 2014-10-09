part of dart_force_mvc_lib;

class HttpRequestStreamer {
  
  StreamController<HttpRequest> _controller;
  
  HttpRequestStreamer() {
    this._controller = new StreamController<HttpRequest>();
  }
  
  void add(HttpRequest request) {
     this._controller.add(request);
  }
  
  Stream<HttpRequest> get stream => _controller.stream;
}