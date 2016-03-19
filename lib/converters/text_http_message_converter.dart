part of dart_force_mvc_lib;

class TextHttpMessageConverter<T> extends HttpMessageConverter<T> {

  canRead(MediaType mediaType) {
    return mediaType.hasSame(MediaType.TEXT_PLAIN) || mediaType.hasSame(MediaType.TEXT_HTML);
  }

  bool	canWrite(MediaType mediaType) {
    return mediaType.hasSame(MediaType.TEXT_PLAIN);
  }

  List<MediaType>	getSupportedMediaTypes() { return [MediaType.TEXT_PLAIN_VALUE]; }

  T	read(HttpInputMessage inputMessage) { return null; }

  void	write(T t, MediaType contentType, HttpOutputMessage outputMessage) {
      // write things to the response ... outputMessage.getBody().
      String text = t.toString();
      outputMessage.getOutputBody().write(text);
  }

}
