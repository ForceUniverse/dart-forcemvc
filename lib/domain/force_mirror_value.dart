part of dart_force_mvc_lib;

class MirrorValue {
  
  String value;
  Symbol memberName;
  MirrorValue(this.value, this.memberName);

  String toString() => "$value - $memberName";
  
}