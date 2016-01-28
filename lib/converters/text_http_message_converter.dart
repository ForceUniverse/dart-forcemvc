part of dart_force_mvc_lib;

class TextHttpMessageConverter<T> extends HttpMessageConverter<T> {

  canRead(MediaType mediaType) {
    return mediaType.equals(MediaType.TEXT_PLAIN_VALUE);
  }

  bool	canWrite(MediaType mediaType) {
    return mediaType.equals(MediaType.TEXT_PLAIN_VALUE);
  }

  List<MediaType>	getSupportedMediaTypes() { return [MediaType.TEXT_PLAIN_VALUE]; }

  T	read(HttpInputMessage inputMessage) { return null; }

  void	write(T t, MediaType contentType, HttpOutputMessage outputMessage) {
      // write things to the response ... outputMessage.getBody().
      String text = t.toString();
      outputMessage.getBody().add(text);
  }

}
