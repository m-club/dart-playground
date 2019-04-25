import 'dart:html';

import 'package:angular/angular.dart';

@Directive(selector: '[myHighlight]')
class HighlightDirective {

  final Element _el;

  HighlightDirective(this._el);

  @HostListener('mouseenter')
  void onMouseEnter() {
    _highlight('yellow');
  }

  @HostListener('mouseleave')
  void onMouseLeave() {
    _highlight();
  }

  void _highlight([String color]) {
    _el.style.backgroundColor = color;
  }
}