import 'package:angular/angular.dart';

import 'package:ngzone/app_component.dart';

import 'main.template.dart' as ng;

void main() {
  bootstrapStatic(AppComponent, [], ng.initReflector);
}
