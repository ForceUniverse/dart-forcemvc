part of dart_force_mvc_lib;

class MirrorValue<T> {
  
  Symbol memberName;
  InstanceMirror instanceMirror;
  T mirror;
  
  MirrorValue(this.mirror, this.memberName, this.instanceMirror);

  String toString() => "$mirror - $memberName";
  
}