import 'dart:html';

void main() {
  Future.delayed(Duration(seconds: 3), () {
    querySelector("#my-title").text = "I changed title from the code!";
  });
}