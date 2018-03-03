---
layout: angular
title: Multiple Components
description: Refactor the master/detail view into separate components.
prevpage:
  title: Master/Detail
  url: /angular/tutorial/toh-pt2
nextpage:
  title: Services
  url: /angular/tutorial/toh-pt4
---
<?code-excerpt path-base="examples/ng/doc/toh-3"?>
The `AppComponent` is doing _everything_ at the moment.
In the beginning, it showed details of a single hero.
Then it became a master/detail form with both a list of heroes and the hero detail.
Soon there will be new requirements and capabilities.
You can't keep piling features on top of features in one component; that's not maintainable.

You'll need to break it up into sub-components, each focused on a specific task or workflow.
Eventually, the `AppComponent` could become a simple shell that hosts those sub-components.

In this page, you'll take the first step in that direction by carving out the hero details into a separate, reusable component.
When you're done, the app should look like this <live-example></live-example>.

## Where you left off

Before getting started on this page, verify that you have the following structure from earlier in the Tour of Heroes.
If not, go back to the previous pages.

<div class="ul-filetree" markdown="1">
- angular_tour_of_heroes
  - lib
    - app_component.{css,dart,html}
    - src
      - hero.dart
      - mock_heroes.dart
  - test
    - app_test.dart
    - ...
  - web
    - index.html
    - main.dart
    - styles.css
  - pubspec.yaml
</div>

{% include_relative _keep-app-running.md %}

## Make a hero detail component

Create a file named `hero_detail_component.dart`.
This file will hold the new `HeroDetailComponent`.

<div class="l-sub-section" markdown="1">
  **Angular conventions**:

  * The component _class_ name should be written in [upper camel case](/angular/glossary#pascalcase) and
    end in the word "Component".  The hero detail component class is
    `HeroDetailComponent`.

  * The component _file_ name should be in [snake case](/angular/glossary#snake_case)
    &mdash;lowercase with underscore separation&mdash;and end in `_component.dart`.
    The `HeroDetailComponent` class goes in the `hero_detail_component.dart` file.

  * Internal implementation files should be placed under `lib/src`. See the
 [pub package layout conventions]({{site.dartlang}}/tools/pub/package-layout)
 for details.
</div>

Start writing the `HeroDetailComponent` as follows:

<?code-excerpt "lib/src/hero_detail_component.dart (initial version)" region="v1" title?>
```
  import 'package:angular/angular.dart';
  import 'package:angular_forms/angular_forms.dart';

  @Component(
    selector: 'hero-detail',
    directives: const [coreDirectives, formDirectives],
  )
  class HeroDetailComponent {
  }
```

<a id="selector"></a>
To define a component, you always import the main Angular library.

The `@Component` annotation provides the Angular metadata for the component.
The CSS selector name, `hero-detail`, will match the element tag
that identifies this component within a parent component's template.
[Near the end of this tutorial page](#add-hero-detail "Add the HeroDetailComponent to the AppComponent"),
you'll add a `<hero-detail>` element to the `AppComponent` template.

### Hero detail template

To move the hero detail view to the `HeroDetailComponent`,
cut the hero detail _content_ from the bottom of the `AppComponent` template
and paste it into a new `template` argument of the `@Component` annotation.

The `HeroDetailComponent` has a _hero_, not a _selected hero_.
Replace the word, "selectedHero", with the word, "hero", everywhere in the template.
When you're done, the new template should look like this:

<?code-excerpt "lib/src/hero_detail_component.dart (template)" title?>
```
  template: '''
    <div *ngIf="hero != null">
      <h2>{!{hero.name}!} details!</h2>
      <div><label>id: </label>{!{hero.id}!}</div>
      <div>
        <label>name: </label>
        <input [(ngModel)]="hero.name" placeholder="name">
      </div>
    </div>''',
```

### Add the *hero* property

The `HeroDetailComponent` template binds to the component's `hero` property.
Add that property, along with the requisite import,
to the `HeroDetailComponent` class.

<?code-excerpt "lib/src/hero_detail_component.dart (hero)" title?>
```
  import 'hero.dart';

  class HeroDetailComponent {
    Hero hero;
  }
```

### The *hero* property is an *input* property

[Later in this page](#add-hero-detail "Add the HeroDetailComponent to the AppComponent"),
the parent `AppComponent` will tell the child `HeroDetailComponent` which hero to display
by binding its `selectedHero` to the `hero` property of the `HeroDetailComponent`.
The binding will look like this:

<?code-excerpt "lib/app_component.html (hero-detail)"?>
```
  <hero-detail [hero]="selectedHero"></hero-detail>
```

Putting square brackets around the `hero` property, to the left of the equal sign (=),
makes it the *target* of a property binding expression.
You must declare a *target* binding property to be an *input* property.
Otherwise, Angular rejects the binding and throws an error.

Declare that `hero` is an *input* property by annotating it with `@Input()`:

<?code-excerpt "lib/src/hero_detail_component.dart (Input annotation)" title?>
```
  @Input()
  Hero hero;
```

<div class="l-sub-section" markdown="1">
  Read more about _input_ properties in the
  [Attribute Directives](../guide/attribute-directives.html#why-input) page.
</div>

That's it. The `hero` property is the only thing in the `HeroDetailComponent` class.
All it does is receive a hero object through its `hero` input property and then bind to that property with its template.
Here's the complete `HeroDetailComponent`.

<?code-excerpt "lib/src/hero_detail_component.dart" title linenums?>
```
  import 'package:angular/angular.dart';
  import 'package:angular_forms/angular_forms.dart';

  import 'hero.dart';

  @Component(
    selector: 'hero-detail',
    template: '''
      <div *ngIf="hero != null">
        <h2>{!{hero.name}!} details!</h2>
        <div><label>id: </label>{!{hero.id}!}</div>
        <div>
          <label>name: </label>
          <input [(ngModel)]="hero.name" placeholder="name">
        </div>
      </div>''',
    directives: const [coreDirectives, formDirectives],
  )
  class HeroDetailComponent {
    @Input()
    Hero hero;
  }
```

<a id="add-hero-detail"></a>
## Add _HeroDetailComponent_ to the _AppComponent_

The `AppComponent` is still a master/detail view.
It used to display the hero details on its own, before you cut out that portion of the template.
Now it will delegate to the `HeroDetailComponent`.

Start by importing the `HeroDetailComponent` so `AppComponent` can refer to it.

<?code-excerpt "lib/app_component.dart (hero-detail import)"?>
```
  import 'src/hero_detail_component.dart';
```

Recall that `hero-detail` is the CSS [`selector`](#selector "HeroDetailComponent selector")
in the `HeroDetailComponent` metadata.
That's the tag name of the element that represents the `HeroDetailComponent`.

Add a `<hero-detail>` element near the bottom of the `AppComponent` template,
where the hero detail view used to be.

Coordinate the master `AppComponent` with the `HeroDetailComponent`
by binding the `selectedHero` property of the `AppComponent`
to the `hero` property of the `HeroDetailComponent`.

<?code-excerpt "lib/app_component.html (hero-detail)"?>
```
  <hero-detail [hero]="selectedHero"></hero-detail>
```

Now every time the `selectedHero` changes, the `HeroDetailComponent` gets a new hero to display.

The revised `AppComponent` template should look like this:

<?code-excerpt "lib/app_component.html" title linenums?>
```
  <h1>{!{title}!}</h1>
  <h2>My Heroes</h2>
  <ul class="heroes">
    <li *ngFor="let hero of heroes"
        [class.selected]="hero === selectedHero"
        (click)="onSelect(hero)">
      <span class="badge">{!{hero.id}!}</span> {!{hero.name}!}
    </li>
  </ul>
  <hero-detail [hero]="selectedHero"></hero-detail>
```

The detail _should_ update every time the user picks a new hero.  It's not
happening yet!  Click a hero. No details. If you look for an error in the
console of the browser development tools. No error.

It is as if Angular were ignoring the new tag. That's because _it is
ignoring the new tag_.

### The *directives* list

A browser ignores HTML tags and attributes that it doesn't recognize. So
does Angular.

You've imported `HeroDetailComponent`, and you've used `<hero-detail>` in
the template, but you haven't told Angular about it.

Just as you've done for the built-in Angular directives, tell Angular
about the hero detail component by listing it in the metadata `directives`
list. You don't need `formDirectives` anymore, so delete it and the
`angular_forms` import at the top of the file:

<?code-excerpt "lib/app_component.dart (directives)" title?>
```
  directives: const [coreDirectives, HeroDetailComponent],
```

<i class="material-icons">open_in_browser</i>
 **Refresh the browser.** The app works!

## App design changes

As [before](./toh-pt2.html), whenever a user clicks on a hero name,
the hero detail appears below the hero list.
But now the `HeroDetailComponent` is presenting those details.

Refactoring the original `AppComponent` into two components yields benefits, both now and in the future:

1. You simplified the `AppComponent` by reducing its responsibilities.
1. You can evolve the `HeroDetailComponent` into a rich hero editor
   without touching the parent `AppComponent`.
1. You can evolve the `AppComponent` without touching the hero detail view.
1. You can reuse the `HeroDetailComponent` in the template of some future parent component.

### Review the app structure

Verify that you have the following structure:

<div class="ul-filetree" markdown="1">
- angular_tour_of_heroes
  - lib
    - app_component.{css,dart,html}
    - src
      - hero.dart
      - hero_detail_component.dart
      - mock_heroes.dart
  - test
    - app_test.dart
    - ...
  - web
    - index.html
    - main.dart
    - styles.css
  - pubspec.yaml
</div>

Here are the code files discussed in this page.

<code-tabs>
  <?code-pane "lib/src/hero_detail_component.dart" linenums?>
  <?code-pane "lib/app_component.dart" linenums?>
  <?code-pane "lib/app_component.html" linenums?>
</code-tabs>

## The road you’ve travelled

Here's what you achieved in this page:

* You created a reusable component.
* You learned how to make a component accept input.
* You learned to declare the app directives in a `directives` list.
* You learned to bind a parent component to a child component.

Your app should look like this <live-example></live-example>.

## The road ahead

The Tour of Heroes app is more reusable with shared components,
but its (mock) data is still hard coded within the `AppComponent`.
That's not sustainable.
Data access should be refactored to a separate service
and shared among the components that need data.

You’ll learn to create services in the [next tutorial](toh-pt4.html) page.
