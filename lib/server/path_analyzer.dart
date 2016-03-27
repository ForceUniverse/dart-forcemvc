part of dart_force_mvc_lib;

class PathAnalyzer {

  String _path;
  String route = "";
  String expression = "([^/]+?)";

  List<String> variables;

  PathAnalyzer(this._path) {
    analyze();
  }

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
        route = "$route$expression";
      } else if (capture) {
        variable = "$variable$ch";
      } else {
        route = "$route$ch";
      }
    }
  }

}
