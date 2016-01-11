part of dart_force_mvc_lib;

class JsonHttpMessageConverter<T> extends HttpMessageConverter<T> {

  canRead(MediaType mediaType) {
    return mediaType.equals(MediaType.JSON);
  }

  bool	canWrite(MediaType mediaType) {
    return mediaType.equals(MediaType.JSON);
  }

  List<MediaType>	getSupportedMediaTypes() { return [MediaType.JSON]; }

  T	read(HttpInputMessage inputMessage) { return null; }

  void	write(T t, MediaType contentType, HttpOutputMessage outputMessage) {
    if (canWrite(contentType)) {
      // write things to the response ... outputMessage.getBody().
      String data = JSON.encode(t);
    }
  }

}
