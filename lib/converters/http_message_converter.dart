part of dart_force_mvc_lib;

abstract class HttpMessageConverter<T> {

  bool canRead(MediaType mediaType) { return false; }

  bool	canWrite(MediaType mediaType) { return false; }

  List<MediaType>	getSupportedMediaTypes() { return new List(); }

  T	read(HttpInputMessage inputMessage) { return null; }

  void	write(T t, MediaType contentType, HttpOutputMessage outputMessage) {}

}
