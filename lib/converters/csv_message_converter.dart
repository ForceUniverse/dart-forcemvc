part of dart_force_mvc_lib;

class CsvMessageConverter<T> extends AbstractHttpMessageConverter<T> {

  CsvMessageConverter() {
    setSupportedMediaTypes([MediaType.TEXT_CSV]);
  }

  T	readInternal(HttpInputMessage inputMessage) { return null; }

  void	writeInternal(T t, HttpOutputMessage output) {
      // write things to the response ... outputMessage.getBody().
      InstanceMirror myClassInstanceMirror = reflect(t);
      ClassMirror nameOfCsv = myClassInstanceMirror.type;

      String name = "$nameOfCsv.csv";
      output.getHeaders().set("Content-Disposition", "attachment; filename=\"" + name + "\"");

      // doing some mirror stuff on the T class
      /* classMirror.variables.keys.forEach((key) {
        var futureField = instanceMirror.getField(key); // <-- works ok
            futureField.then((imField) => print("Field: $key=${imField.reflectee}"));
        });
      }
      classMirror.getters.keys.forEach((key) {
        var futureValue = instanceMirror.getField(key); // <-- now works ok
        futureValue.then((imValue) => print("Field: $key=${imValue.reflectee}"));
      }); */
   }
}
