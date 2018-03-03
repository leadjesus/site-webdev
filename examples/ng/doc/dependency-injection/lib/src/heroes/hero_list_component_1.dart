// #docregion
import 'package:angular/angular.dart';

import 'hero.dart';
import 'mock_heroes.dart';

@Component(
  selector: 'hero-list',
  template: '''
    <div *ngFor="let hero of heroes">
      {{hero.id}} - {{hero.name}}
    </div>''',
  directives: const [coreDirectives],
)
// #docregion class
class HeroListComponent {
  final List<Hero> heroes = mockHeroes;
}
