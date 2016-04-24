part of dart_force_mvc_lib;

class CsvMessageConverter<List> extends AbstractHttpMessageConverter<List> {

  CsvMessageConverter() {
    setSupportedMediaTypes([MediaType.TEXT_CSV]);
  }

  List	readInternal(HttpInputMessage inputMessage) { return null; }

  void	writeInternal(List list, HttpOutputMessage output) {
      // write things to the response ... outputMessage.getBody().
      String name;
      String outputFile;

      for (var obj in list) {
        InstanceMirror myClassInstanceMirror = reflect(obj);
        ClassMirror classMirror = myClassInstanceMirror.type;

        name = "$classMirror.csv";
        /* for (var key in myClassInstanceMirror.) {

        }*/
        outputFile = "$outputFile \n";
        for (var v in classMirror.declarations.values) {
          var value = classMirror.invokeGetter(v.simpleName);

          outputFile = "$outputFile${value};";
        }

      }
      output.getHeaders().set("Content-Disposition", "attachment; filename=\"" + name + "\"");

      outputMessage.getOutputBody().write(outputFile);
   }
}
