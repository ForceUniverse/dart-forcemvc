part of dart_force_mvc_lib;

class CsvMessageConverter<List> extends AbstractHttpMessageConverter<List> {

  CsvMessageConverter() {
    setSupportedMediaTypes([MediaType.TEXT_CSV]);
  }

  List	readInternal(HttpInputMessage inputMessage) { return null; }

  void	writeInternal(List list, HttpOutputMessage outputMessage) {
      // write things to the response ... outputMessage.getBody().
      String name, outputFile = "";

      for (var obj in list) {
        InstanceMirror myClassInstanceMirror = reflect(obj);
        ClassMirror classMirror = myClassInstanceMirror.type;
        name = "$classMirror.csv";

        for (var v in classMirror.declarations.values) {
          if (v is VariableMirror) {
            var value = myClassInstanceMirror.getField(v.simpleName);
            outputFile = "${outputFile}${value.reflectee};";
          }
        }
        outputFile = "$outputFile \n";
      }
      try {
        outputMessage.getResponseHeaders().add("Content-Disposition", "attachment; filename=\"$name\"");
      } catch (e) {
        print(e);
      }
      outputMessage.getOutputBody().write(outputFile);
   }
}
