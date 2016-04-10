part of dart_force_mvc_lib;

class CsvMessageConverter<T> extends HttpMessageConverter<T> {

  canRead(MediaType mediaType) {
    return mediaType.hasSame(MediaType.TEXT_CSV);
  }

  bool	canWrite(MediaType mediaType) {
    return mediaType.hasSame(MediaType.TEXT_CSV);
  }

  List<MediaType>	getSupportedMediaTypes() { return [MediaType.TEXT_CSV]; }

  T	read(HttpInputMessage inputMessage) { return null; }

  void	write(T t, MediaType contentType, HttpOutputMessage outputMessage) {
      // write things to the response ... outputMessage.getBody().

  }

}
