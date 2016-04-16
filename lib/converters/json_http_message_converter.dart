part of dart_force_mvc_lib;

class JsonHttpMessageConverter<T> extends AbstractHttpMessageConverter<T> {

  JsonHttpMessageConverter() {
    setSupportedMediaTypes([MediaType.APPLICATION_JSON]);
  }

  List<MediaType>	getSupportedMediaTypes() { return [MediaType.APPLICATION_JSON]; }

  T	readInternal(HttpInputMessage inputMessage) { return null; }

  void	writeInternal(T t, HttpOutputMessage outputMessage) {
      // write things to the response ... outputMessage.getBody().
      String data = JSON.encode(t);
      outputMessage.getOutputBody().write(data);
  }

}
