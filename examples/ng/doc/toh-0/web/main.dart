import 'package:angular/angular.dart';

import 'package:angular_tour_of_heroes/app_component.dart';
import 'package:angular_tour_of_heroes/app_component.template.dart';

void main() {
  initReflector();
  bootstrapStatic(AppComponent);
}
