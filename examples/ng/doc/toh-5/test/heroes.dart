// #docregion
@TestOn('browser')

import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';
import 'package:angular_test/angular_test.dart';
import 'package:angular_tour_of_heroes/src/heroes_component.dart';
import 'package:angular_tour_of_heroes/src/hero_service.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'heroes_po.dart';

// #docregion providers-with-context
NgTestFixture<HeroesComponent> fixture;
HeroesPO po;

final mockRouter = new MockRouter();

class MockRouter extends Mock implements Router {}

void main() {
  // #docregion providers
  final testBed = new NgTestBed<HeroesComponent>().addProviders([
    HeroService,
    provide(Router, useValue: mockRouter),
  ]);
  // #enddocregion providers

  setUp(() async {
    fixture = await testBed.create();
    po = await new HeroesPO().resolve(fixture);
  });

  tearDown(disposeAnyRunningTest);
  // #enddocregion providers-with-context

  group('Basics:', basicTests);
  group('Selected hero:', selectedHeroTests);
  // #docregion providers-with-context
}
// #enddocregion providers-with-context

void basicTests() {
  test('title', () async {
    expect(await po.title, 'My Heroes');
  });

  test('hero count', () async {
    expect(po.heroes.length, 10);
  });

  test('no selected hero', () async {
    expect(await po.selectedHero, null);
  });
}

// #docregion go-to-detail
void selectedHeroTests() {
  const targetHero = const {'id': 15, 'name': 'Magneta'};

  setUp(() async {
    await po.selectHero(4);
    po = await new HeroesPO().resolve(fixture);
  });

  // #enddocregion go-to-detail
  test('is selected', () async {
    expect(await po.selectedHero, targetHero);
  });

  test('show mini-detail', () async {
    expect(
        await po.myHeroNameInUppercase, equalsIgnoringCase(targetHero['name']));
  });

  // #docregion go-to-detail
  test('go to detail', () async {
    await po.gotoDetail();
    final c = verify(mockRouter.navigate(typed(captureAny)));
    expect(c.captured.single, '/detail/${targetHero['id']}');
  });
  // #enddocregion go-to-detail

  test('select another hero', () async {
    await po.selectHero(0);
    po = await new HeroesPO().resolve(fixture);
    final heroData = {'id': 11, 'name': 'Mr. Nice'};
    expect(await po.selectedHero, heroData);
  });
  // #docregion go-to-detail
}
