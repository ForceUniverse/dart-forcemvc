part of dart_force_mvc_lib;

class ForceRegistry {
  
  WebServer webServer;
  File _basePath;
  
  ForceRegistry(this.webServer) {
    _basePath = new File(Platform.script.toFilePath());
  }

  void loadValues(String path) {
     var valuesUri = new Uri.file(_basePath.path).resolve(path);
     var file = new File(valuesUri.toFilePath());
     file.readAsBytes().then((data) {
          var yaml = new String.fromCharCodes(data);
              
          ApplicationContext.registerMessage(path, yaml);
     });
  }
  
  void scanning() {
      ApplicationContext.bootstrap();
    
      Scanner<Controller, Object> classesHelper = new Scanner<Controller, Object>();
      List<Object> classes = ApplicationContext.component(classesHelper);
      
      for (var obj in classes) {
        this.register(obj);
      }
  }
  
  void register(Object obj) {
        List<MetaDataValue<RequestMapping>> mirrorValues = new MetaDataHelper<RequestMapping>().getMirrorValues(obj);
        List<MetaDataValue<ModelAttribute>> mirrorModels = new MetaDataHelper<ModelAttribute>().getMirrorValues(obj); 
        
        AnnotationChecker<Authentication> annoChecker = new AnnotationChecker<Authentication>();
        bool auth = annoChecker.hasOnClazz(obj);
        
        for (MetaDataValue mv in mirrorValues) {
              // execute all ! ! !
          PathAnalyzer pathAnalyzer = new PathAnalyzer(mv.object.value);
          UrlPattern urlPattern = new UrlPattern(pathAnalyzer.route);
          this.webServer.on(urlPattern, (ForceRequest req, Model model) {
              // prepare model  
              for (MetaDataValue mvModel in mirrorModels) {
                  
                  InstanceMirror res = mvModel.invoke([]);
                  
                  if (res != null && res.hasReflectee) {
                    model.addAttribute(mvModel.object.value, res.reflectee);
                  }
              }
              // search for path variables
              for (var i = 0; pathAnalyzer.variables.length>i; i++) { 
                var variableName = pathAnalyzer.variables[i], 
                    value = urlPattern.parse(req.request.uri.path)[i];
                req.path_variables[variableName] = value;
              }
               
              List<dynamic> positionalArguments = _calculate_positionalArguments(mv, model, req);
              
              InstanceMirror res = mv.invoke(positionalArguments);
                
              if (res != null && res.hasReflectee) {
                  return res.reflectee;
                }
             }, method: mv.object.method, authentication: auth);
        }
    }
    
    List<dynamic> _calculate_positionalArguments(MetaDataValue<RequestMapping> mv, Model model, ForceRequest req) {
        List<dynamic> positionalArguments = new List<dynamic>();
        for (ParameterMirror pm in mv.parameters) {
            String name = (MirrorSystem.getName(pm.simpleName));
            
            if (pm.type is Model || name == 'model') {
              positionalArguments.add(model);
            } else if (pm.type is ForceRequest || name == 'req') {
              positionalArguments.add(req);
            } else if (pm.type is HttpSession || name == 'session') {
              positionalArguments.add(req.request.session);
            } else if (pm.type is HttpHeaders || name == 'headers') {
              positionalArguments.add(req.request.headers);
            } else {
              if (req.path_variables[name] != null) {
                positionalArguments.add(req.path_variables[name]);
              } else {
               for ( InstanceMirror im  in pm.metadata ) {
                 if ( im.reflectee is PathVariable ) {
                   PathVariable pathVariable = im.reflectee;
                   if (req.path_variables[pathVariable.value] != null) {
                      positionalArguments.add(req.path_variables[pathVariable.value]);
                   }
                 }
                 if ( im.reflectee is RequestParam) {
                   RequestParam rp = im.reflectee;
                   if (req.request.uri.queryParameters[rp.value] != null) {
                     positionalArguments.add(req.request.uri.queryParameters[rp.value]);
                   } else {
                     positionalArguments.add(rp.defaultValue);
                   }
                 }
               }
              }
            }
        }
        if (positionalArguments.isEmpty && mv.parameters.length == 2) {
             positionalArguments = [req, model];
        }
        return positionalArguments;
    }
}