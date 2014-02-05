part of dart_force_mvc_lib;

class MirrorHelpers<T> {
  
  List<MirrorValue<T>> getMirrorValues(Object obj) {
    InstanceMirror instanceMirror = reflect(obj);
    ClassMirror MyClassMirror = instanceMirror.type;
   
    Iterable<DeclarationMirror> decls =
        MyClassMirror.declarations.values;
    
    List<MirrorValue> mirrorValues = new List<MirrorValue>();
    
    for (DeclarationMirror dclMirror in decls) {
      if (dclMirror is MethodMirror) {
        MethodMirror mm = dclMirror;
        if (mm.metadata.isNotEmpty) {
          // var request = mm.metadata.first.reflectee;
          for (var im in mm.metadata) {
            if (im.reflectee is T) {
              var request = im.reflectee;
              String name = (MirrorSystem.getName(mm.simpleName));
              Symbol memberName = mm.simpleName;
              
              mirrorValues.add(new MirrorValue<T>(request, memberName, instanceMirror));
            }
          }
        }
      }
    }
    return mirrorValues;
  }
  
  
}