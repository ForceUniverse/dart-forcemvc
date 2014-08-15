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
     var yaml = file.readAsStringSync();
     
     ApplicationContext.registerMessage(path, yaml);
  }
  
  void scanning() {
      ApplicationContext.bootstrap();
    
      /* scan for controllers */
      Scanner<_Controller, Object> controllerClasHelper = new Scanner<_Controller, Object>();
      List<Object> classes = ApplicationContext.component(controllerClasHelper);
      
      /* scan for controllerAdvice classes */
      Scanner<_ControllerAdvice, Object> adviserHelper = new Scanner<_ControllerAdvice, Object>();
      List<Object> adviserObjects = ApplicationContext.component(adviserHelper);
      
      List<MetaDataValue<ModelAttribute>> adviserModels = new List<MetaDataValue<ModelAttribute>>();
      List<MetaDataValue<ExceptionHandler>> adviserExc = new List<MetaDataValue<ExceptionHandler>>();
      for (var obj in adviserObjects) {
        adviserModels.addAll(new MetaDataHelper<ModelAttribute>().getMirrorValues(obj));
        adviserExc.addAll(new MetaDataHelper<ExceptionHandler>().getMirrorValues(obj));
      }
      
      /* now register all the controller classes */
      for (var obj in classes) {
        this._register(obj, adviserModels, adviserExc);
      }
  }
  
  void register(Object obj) {
    this._register(obj, new List<MetaDataValue<ModelAttribute>>(), new List<MetaDataValue<ExceptionHandler>>());     
  }
  
  void _register(Object obj, List<MetaDataValue<ModelAttribute>> adviserModels, List<MetaDataValue<ExceptionHandler>> adviserExc) {
        List<MetaDataValue<RequestMapping>> mirrorValues = new MetaDataHelper<RequestMapping>().getMirrorValues(obj);
        List<MetaDataValue<ModelAttribute>> mirrorModels = new MetaDataHelper<ModelAttribute>().getMirrorValues(obj); 
        mirrorModels.addAll(adviserModels);
        
        bool auth = MVCAnnotationHelper.hasAuthentication(obj);
        
        String startPath = _findStartPath(obj);
        
        for (MetaDataValue mv in mirrorValues) {
          // execute all ! ! !
          PathAnalyzer pathAnalyzer = new PathAnalyzer(mv.object.value);

          UrlPattern urlPattern = new UrlPattern("${startPath}${pathAnalyzer.route}");
          this.webServer.on(urlPattern, (ForceRequest req, Model model) {
              try {  
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
                 
                List positionalArguments = _calculate_positionalArguments(mv, model, req);
                return _executeFunction(mv, positionalArguments);
              } catch(e) {
                // Look for exceptionHandlers in this case 
                List<MetaDataValue<ExceptionHandler>> mirrorExceptions = new MetaDataHelper<ExceptionHandler>().getMirrorValues(obj); 
                mirrorExceptions.addAll(adviserExc);
                
                return _errorHandling(mirrorExceptions, model, req, e);
              }
            }, method: mv.object.method, authentication: auth);
        }
    }

    _errorHandling(List<MetaDataValue<ExceptionHandler>> mirrorExceptions, Model model, ForceRequest req, e) {
      if (mirrorExceptions.length==0) {
        throw e;
      } else {
        MetaDataValue mdvException = mirrorExceptions.first;
        
        List positionalArguments = _calculate_positionalArguments(mdvException, model, req, e);
        return _executeFunction(mdvException, positionalArguments);
      }
    }

    _executeFunction(MetaDataValue mdv, List positionalArguments) {
      InstanceMirror res = mdv.invoke(positionalArguments);
      return res.reflectee;
    }
    
    List _calculate_positionalArguments(MetaDataValue mv, Model model, ForceRequest req, [ex_er]) {
        List positionalArguments = new List();
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
            } else if (pm.type is Exception || name == 'exception') {
              positionalArguments.add(ex_er);
            } else if (pm.type is Error || name == 'error') {
              positionalArguments.add(ex_er);
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
                   String qvalue= (rp.value==""?name:rp.value);
                   if (req.request.uri.queryParameters[qvalue] != null) {
                     positionalArguments.add(req.request.uri.queryParameters[qvalue]);
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
    
    String _findStartPath(Object obj) {
      InstanceMirror objMirror = reflect(obj);
      String startPath="";
      for (var meta in objMirror.type.metadata) {
           if (meta.reflectee is RequestMapping) {
               RequestMapping reqMapping = meta.reflectee;
               startPath = reqMapping.value;
           }
      }
      return startPath;
    }
}