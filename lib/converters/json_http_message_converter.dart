part of dart_force_mvc_lib;

class JsonHttpMessageConverter<T> extends HttpMessageConverter<T> {

  canRead(MediaType mediaType) {
    return mediaType.hasSame(MediaType.APPLICATION_JSON);
  }

  bool canWrite(MediaType mediaType) {
    return mediaType.hasSame(MediaType.APPLICATION_JSON);
  }

  List<MediaType>	getSupportedMediaTypes() { return [MediaType.APPLICATION_JSON]; }

  T	read(HttpInputMessage inputMessage) { return null; }

  void	write(T t, MediaType contentType, HttpOutputMessage outputMessage) {
      // write things to the response ... outputMessage.getBody().
      String data = JSON.encode(t);
      outputMessage.getOutputBody().write(data);
  }

}
