part of dart_force_mvc_lib;

class HttpMessageRegulator {

  List<HttpMessageConverter> messageConverters = new List();

  HttpMessageRegulator() {
     add(new JsonHttpMessageConverter());
     add(new CsvMessageConverter());
  }

  add(HttpMessageConverter messageConverter) {
     messageConverters.add(messageConverter);
  }

  loopOverMessageConverters(ForceRequest req, Object obj) {
    List<MediaType> mediaTypes = req.getRequestHeaders().getAccept();
    for (MediaType mediaType in mediaTypes) {
      for (HttpMessageConverter messageConverter in messageConverters) {
          if (messageConverter.canWrite(mediaType)) {
             messageConverter.write(obj, mediaType, req);
          }
      }
    }
  }

}
