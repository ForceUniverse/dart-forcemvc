part of dart_force_mvc_lib;

class CsvMessageConverter<T> extends AbstractHttpMessageConverter<T> {

  CsvMessageConverter() {
    setSupportedMediaTypes([MediaType.TEXT_CSV]);
  }

  T	readInternal(HttpInputMessage inputMessage) { return null; }

  void	writeInternal(T t, HttpOutputMessage output) {
      // write things to the response ... outputMessage.getBody().
      String name = "response.csv";
      output.getHeaders().set("Content-Disposition", "attachment; filename=\"" + name + "\"");

      // doing some mirror stuff on the T class
  }

}
