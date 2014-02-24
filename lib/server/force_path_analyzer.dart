part of dart_force_mvc_lib;

class PathAnalyzer {
  
  String _path;
  String _route;
  List<String> variables;
  
  PathAnalyzer(this._path);
  
  void analyze() {
    variables = new List<String>();
    
    bool capture = false;
    String variable = "";
    var chars_raw = this._path.split("");
    for (var ch in chars_raw) {
      if (ch == "{") {
        capture = true;
        variable = "";
      } else if (ch == "}") {
        capture = false;
        variables.add(variable);
        _route = "$_route([/|.|\w|\s])";
      } else if (capture) {
        variable = "$variable$ch";
      } else {
        _route = "$_route$ch";
      }
    }
  }
  
}