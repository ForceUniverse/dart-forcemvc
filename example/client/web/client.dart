import 'dart:async';
import 'dart:html';

// This is a client side dart script needed by dart force in order to 
// bootstrap the client side of the application (?) 

void main() {
  DivElement statusElement = querySelector('#status');
  statusElement.innerHtml = "Js / dart is up and running!";
}
