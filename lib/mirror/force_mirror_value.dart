part of dart_force_mvc_lib;

class MirrorValue {
  
  String value;
  Symbol memberName;
  InstanceMirror instanceMirror;
  MirrorValue(this.value, this.memberName, this.instanceMirror);

  String toString() => "$value - $memberName";
  
}