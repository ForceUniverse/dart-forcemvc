part of dart_force_mvc_lib;

abstract class ForceViewRender {
  final Logger log = new Logger('ForceViewRender');
  String views;
  String clientFiles;
  bool clientServe;
  
  ServingAssistent servingAssistent;
  
  ForceViewRender(this.servingAssistent, [this.views, this.clientFiles, this.clientServe]) {
    // Check so that we have a server side views directory exists  
    views = Platform.script.resolve(views).toFilePath();
    
    _exists(views);
    
    // If we should serve client files, check that pub build has been run
    // or use the pub serve tric 
    if(clientServe == true) {
      clientFiles = Platform.script.resolve(clientFiles).toFilePath();
            
      _exists(clientFiles);
    }
  }
  
  void _exists(dir) {
    try {
      if (!new Directory(dir).existsSync()) {
         log.severe("The '$dir' directory was not found.");
      }
    } on FileSystemException {
      log.severe("The '$dir' directory was not found.");
    }
  }
  
  Future<String> render(String view, model) async {
    var viewUri = new Uri.file(views).resolve("$view.html");
    var file = new File(viewUri.toFilePath());
    var result = "";
    
    if (file.existsSync()) {
      result = await _readFile(file, model);
    } else {
      if (servingAssistent!=null) {
        try {
          Stream<List<int>> inputStream = await servingAssistent.read(clientFiles, "$view.html");
          var template = await inputStream.transform(UTF8.decoder).first;
          result = _render_impl(template, model);       
        } catch(e) {
          log.severe("The '$view' can't be resolved.");
        }
      } else {
        viewUri = new Uri.file(clientFiles).resolve("$view.html");
        file = new File(viewUri.toFilePath());
        if (file.existsSync()) {
          result = await _readFile(file, model);
        }
      }
    }
    
    return result;
  }
  
  Future<String> _readFile(File file, model) async {
    var data = await file.readAsBytes();
    var template = new String.fromCharCodes(data);
    return _render_impl(template, model);
  }
  
  String _render_impl(String template, model);
}

