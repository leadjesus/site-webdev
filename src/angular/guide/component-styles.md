---
layout: angular
title: Component Styles
description: Learn how to apply CSS styles to components.
sideNavGroup: advanced
prevpage:
  title: Attribute Directives
  url: /angular/guide/attribute-directives
nextpage:
  title: Deployment
  url: /angular/guide/deployment
---
<?code-excerpt path-base="examples/ng/doc/component-styles"?>
{%comment%}TODO: consider adding material equivalent to TS Appendices 1 & 2 if relevant.{%endcomment%}

Angular applications are styled with standard CSS. That means you can apply
everything you know about CSS stylesheets, selectors, rules, and media queries
directly to Angular applications.

Additionally, Angular can bundle *component styles*
with components, enabling a more modular design than regular stylesheets.

This page describes how to load and apply these component styles.

Run the <live-example></live-example> of the code shown in this page.

## Using component styles

For every Angular component you write, you may define not only an HTML template,
but also the CSS styles that go with that template,
specifying any selectors, rules, and media queries that you need.

One way to do this is to set the `styles` property in the component metadata.
The `styles` property takes a list of strings that contain CSS code.
Usually you give it one string, as in the following example:

<?code-excerpt "lib/app_component.dart" title?>
```
  @Component(
      selector: 'hero-app',
      template: '''
        <h1>Tour of Heroes</h1>
        <hero-app-main [hero]="hero"></hero-app-main>''',
      styles: const ['h1 { font-weight: normal; }'],
      directives: const [HeroAppMainComponent])
  class AppComponent {
  // ···
  }
```

The selectors you put into a component's styles apply only within the template
of that component. The `h1` selector in the preceding example applies only to the `<h1>` tag
in the template of `HeroAppComponent`. Any `<h1>` elements elsewhere in
the app are unaffected.

This is a big improvement in modularity compared to how CSS traditionally works.

* You can use the CSS class names and selectors that make the most sense in the context of each component.
* Class names and selectors are local to the component and don't collide with
  classes and selectors used elsewhere in the app.
* Changes to styles elsewhere in the app don't affect the component's styles.
* You can co-locate the CSS code of each component with the Dart and HTML code of the component,
  which leads to a neat and tidy project structure.
* You can change or remove component CSS code without searching through the
  whole app to find where else the code is used.

## Special selectors

Component styles have a few special *selectors* from the world of shadow DOM style scoping
(described in the [CSS Scoping Module Level 1](https://www.w3.org/TR/css-scoping-1) page on the
[W3C](https://www.w3.org) site).
The following sections describe these selectors.

### :host

Use the `:host` pseudo-class selector to target styles in the element that *hosts* the component (as opposed to
targeting elements *inside* the component's template).

<?code-excerpt "lib/src/hero_details_component.css (host)" title?>
```
  :host {
    display: block;
    border: 1px solid black;
  }
```

The `:host` selector is the only way to target the host element. You can't reach
the host element from inside the component with other selectors because it's not part of the
component's own template. The host element is in a parent component's template.

Use the *function form* to apply host styles conditionally by
including another selector inside parentheses after `:host`.

The next example targets the host element again, but only when it also has the `active` CSS class.

<?code-excerpt "lib/src/hero_details_component.css (host function)" title?>
```
  :host(.active) {
    border-width: 3px;
  }
```

### :host-context

Sometimes it's useful to apply styles based on some condition *outside* of a component's view.
For example, a CSS theme class could be applied to the document `<body>` element, and
you want to change how your component looks based on that.

Use the `:host-context()` pseudo-class selector, which works just like the function
form of `:host()`. The `:host-context()` selector looks for a CSS class in any ancestor of the component host element,
up to the document root. The `:host-context()` selector is useful when combined with another selector.

The following example applies a `background-color` style to all `<h2>` elements *inside* the component, only
if some ancestor element has the CSS class `theme-light`.

<?code-excerpt "lib/src/hero_details_component.css (host-context)" title?>
```
  :host-context(.theme-light) h2 {
    background-color: #eef;
  }
```

### ::ng-deep

Component styles normally apply only to the HTML in the component's own template.

Use the `::ng-deep` selector to force a style down through the child component tree into all the child component views.
The `::ng-deep` selector works to any depth of nested components, and it applies to both the view
children and content children of the component.

The following example targets all `<h3>` elements, from the host element down
through this component to all of its child elements in the DOM.

<?code-excerpt "lib/src/hero_details_component.css (deep)" title?>
```
  :host ::ng-deep h3 {
    font-style: italic;
  }
```

<div class="alert alert-warning" markdown="1">
  Use the `::ng-deep` selector only with *emulated* view encapsulation.
  Emulated is the default and most commonly used view encapsulation. For more information, see the
  [Controlling view encapsulation](#view-encapsulation) section.
</div>

<div id="loading-styles"></div>
## Loading styles into components

There are several ways to add styles to a component:
* By setting `styles` or `styleUrls` metadata.
* Inline in the template HTML.
* With CSS imports.

The scoping rules outlined earlier apply to each of these loading patterns.

### Styles in metadata

You can add a `styles` list property to the `@Component` annotation.
Each string in the list (usually just one string) defines the CSS.

<?code-excerpt "lib/app_component.dart" title?>
```
  @Component(
      selector: 'hero-app',
      template: '''
        <h1>Tour of Heroes</h1>
        <hero-app-main [hero]="hero"></hero-app-main>''',
      styles: const ['h1 { font-weight: normal; }'],
      directives: const [HeroAppMainComponent])
  class AppComponent {
  // ···
  }
```

### Style URLs in metadata

You can load styles from external CSS files by adding a `styleUrls` attribute
into a component's `@Component` annotation:

<?code-excerpt "lib/src/hero_details_component.dart (styleUrls)" title?>
```
  @Component(
      selector: 'hero-details',
      template: '''
        <h2>{!{hero.name}!}</h2>
        <hero-team [hero]="hero"></hero-team>
        <ng-content></ng-content>''',
      styleUrls: const ['hero_details_component.css'],
      directives: const [HeroTeamComponent])
  class HeroDetailsComponent {
    // ···
  }
```

Note that the URLs in `styleUrls` are relative to the component.

{%comment%}
TODO: determine if an equivalent of the TS "module bundlers" material is relevant for Dart.
{%endcomment%}

### Template inline styles

You can embed styles directly into the HTML template by putting them
inside `<style>` tags.

<?code-excerpt "lib/src/hero_controls_component.dart (inline styles)" title?>
```
  @Component(
      selector: 'hero-controls',
      template: '''
        <style>
          button {
            background-color: white;
            border: 1px solid #777;
          }
        </style>
        <h3>Controls</h3>
        <button (click)="activate()">Activate</button>''')
  class HeroControlsComponent {
    @Input()
    Hero hero;

    void activate() {
      hero.active = true;
    }
  }
```

### Template link tags

You can also embed `<link>` tags into the component's HTML template.

The link tag's `href` URL is relative to the
app root, not the component file.

<?code-excerpt "lib/src/hero_team_component.dart (stylesheet link)" title?>
```
  @Component(
    selector: 'hero-team',
    template: '''
        <link rel="stylesheet" href="hero_team_component.css">
        <h3>Team</h3>
        <ul>
          <li *ngFor="let member of hero.team">
            {!{member}!}
          </li>
        </ul>''',
    directives: const [CORE_DIRECTIVES],
  )
  class HeroTeamComponent {
    @Input()
    Hero hero;
  }
```

### CSS @imports

You can also import CSS files into the CSS files using the standard CSS `@import` rule.
For details, see [`@import`](https://developer.mozilla.org/en/docs/Web/CSS/@import)
on the [MDN](https://developer.mozilla.org) site.

In *this* case the URL is relative to the CSS file into which we are importing.

<?code-excerpt "lib/src/hero_details_component.css (excerpt)" region="import" title?>
```
  @import 'hero_details_box.css';
```

<div id="view-encapsulation"></div>
## Controlling view encapsulation: native, emulated, and none

As discussed earlier, component CSS styles are encapsulated into the component's view and don't
affect the rest of the app.

To control how this encapsulation happens on a *per
component* basis, you can set the *view encapsulation mode* in the component metadata.
Choose from the following modes:

* `Native` view encapsulation uses the browser's native shadow DOM implementation (see
  [Shadow DOM](https://developer.mozilla.org/en-US/docs/Web/Web_Components/Shadow_DOM)
  on the [MDN](https://developer.mozilla.org) site)
  to attach a shadow DOM to the component's host element, and then puts the component
  view inside that shadow DOM. The component's styles are included within the shadow DOM.
* `Emulated` view encapsulation (the default) emulates the behavior of shadow DOM by preprocessing
  (and renaming) the CSS code to effectively scope the CSS to the component's view.
  For details, see [Appendix 1](#inspect-generated-css).
* `None` means that Angular does no view encapsulation.
  Angular adds the CSS to the global styles.
  The scoping rules, isolations, and protections discussed earlier don't apply.
  This is essentially the same as pasting the component's styles into the HTML.

To set the components encapsulation mode, use the `encapsulation` property in the component metadata:

<?code-excerpt "lib/src/quest_summary_component.dart (native encapsulation)" title?>
```
  // warning: few browsers support shadow DOM encapsulation at this time
  encapsulation: ViewEncapsulation.Native
```

`Native` view encapsulation only works on browsers that have native support
for shadow DOM (see [Shadow DOM v0](http://caniuse.com/#feat=shadowdom) on the
[Can I use](http://caniuse.com) site). The support is still limited,
which is why `Emulated` view encapsulation is the default mode and recommended
in most cases.

<div id="inspect-generated-css"></div>
## Appendix 1: Inspecting the CSS generated in emulated view encapsulation

When using emulated view encapsulation, Angular preprocesses
all component styles so that they approximate the standard shadow CSS scoping rules.

In the DOM of a running Angular app with emulated view
encapsulation enabled, each DOM element has some extra classes
attached to it:

<?code-excerpt?>
```html
  <hero-details class="_nghost-pmm-5">
    <h2 class="_ngcontent-pmm-5">Mister Fantastic</h2>
    <hero-team class="_ngcontent-pmm-5 _nghost-pmm-6">
      <h3 class="_ngcontent-pmm-6">Team</h3>
    </hero-team>
  </hero-detail>
```

There are two kinds of generated classes:
* An element that would be a shadow DOM host in native encapsulation has a
  generated `_nghost` class. This is typically the case for component host elements.
* An element within a component's view has a `_ngcontent` class
that identifies to which host's emulated shadow DOM this element belongs.

The exact values of these classes aren't important. They are automatically
generated and you never refer to them in app code. But they are targeted
by the generated component styles, which are in the `<head>` section of the DOM:

<?code-excerpt?>
```css
  ._nghost-pmm-5 {
    display: block;
    border: 1px solid black;
  }

  h3._ngcontent-pmm-6 {
    background-color: white;
    border: 1px solid #777;
  }
  ```

These styles are post-processed so that each selector is augmented
with `_nghost` or `_ngcontent` class selectors.
These extra selectors enable the scoping rules described in this page.

<div id="relative-urls"></div>
## Appendix 2: Loading styles with relative URLs

It's common practice to split a component's code, HTML, and CSS into three separate files in the same directory:

  - `quest_summary_component.dart`
  - `quest_summary_component.html`
  - `quest_summary_component.css`

You include the template and CSS files by setting the `templateUrl` and `styleUrls` metadata properties respectively.
Because these files are co-located with the component,
it would be nice to refer to them by name without also having to specify a path back to the root of the app.

Thankfully, this is the default interpretation of relative URLs in AngularDart:

<?code-excerpt "lib/src/quest_summary_component.dart (urls)"?>
```
  templateUrl: 'quest_summary_component.html',
  styleUrls: const ['quest_summary_component.css'])
```
