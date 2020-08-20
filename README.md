# Stackable

<img src="https://github.com/Rightpoint/Stackable/blob/develop/docs/LogoRender.png" height="300">

**Stackable** is a delightful and declarative set of utilities for `UIStackView`. It is designed to make your layout code easier to write, read, and communicate with your designer.

[![CI Status](https://img.shields.io/travis/jason.clark@raizlabs.com/Stackable.svg?style=flat)](https://travis-ci.org/jason.clark@raizlabs.com/Stackable)
[![Version](https://img.shields.io/cocoapods/v/Stackable.svg?style=flat)](https://cocoapods.org/pods/Stackable)
[![License](https://img.shields.io/cocoapods/l/Stackable.svg?style=flat)](https://cocoapods.org/pods/Stackable)
[![Platform](https://img.shields.io/cocoapods/p/Stackable.svg?style=flat)](https://cocoapods.org/pods/Stackable)

Stackable aims to bridge the gap between the way designers articulate layout and the way developers express that layout in code.

```swift
  stack.stackable.add([
      logo,
      30,
      "Example Views",
      10,
      cells
          .outset(to: view)
          .margins(alignedWith: contentView),
      UIStackView.stackable.hairlines(around: cells)
          .outset(to: view),
      20...,
      "Copyright Rightpoint",
  ])
```

<img src="https://github.com/Rightpoint/Stackable/blob/develop/docs/MenuExampleRender.png" height="600">

## Views
**Stackable** includes built-in support for all `UIView` subclasses.

Add them using `stackView.stackable.add(_ stackables: [Stackable])`

```swift
  stack.stackable.add([
      imageView,
      label,
      button,
  ])
```

Additionally, you can reference `UIViewController` directly to include its view.

```swift
  stack.stackable.add([
      viewController,
      button,
  ])
```

There is also support for:
  - `String`
  - `NSAttributedString`
  - `UIImage`

```swift
  stack.stackable.add([
      "String",
      NSAttributedString(string: "Attributed String"),
      UIImage(named: "example"),
  ])
```

#### Alignment
Views can be expressively manipulated to adjust their alignment in a `UIStackView`.

```swift
  let stack = UIStackView()
  stack.axis = .vertical
  stack.stackable.add([
      imageView
        .inset(by: .init(top: 20, left: 20, bottom: 20, right: 20), //imageView padded on all sides 20px
      
      label
        .inset(by: .init(top: 0, left: -20, bottom: 0, right: -20) //inset can also be negative to move outside of bounds of `stack`
        .aligned(.right), // aligned right (transforms are composable)
        
      button
        .aligned(.centerX), // button aligned center horizontally
        
      hairline
        .outset(to: view), // hairline pinned to horizontal edges of `view`
        
      cells
        .outset(to:  view) // cells horizontal edges pinned to horizontal edges of `view`
        .margins(alignedWith: view), // cell layout margins updated to line up with view.layoutMarginsGuide
  ])
```

## Spaces

Spaces can be added using a number literal or `StackableSpaceItem`. Add them alongside your views.

#### Fixed Spaces
```swift
  stack.stackable.add([
      20, //constant space
      viewA,
      20, //custom spacing after `viewA`, will be removed if viewA is hidden.
      viewB,
      12.5, //floating point works too!
      viewC,
      UIStackView.stackable.constantSpace(20), //Constant space, not dependent on visibility of `viewC`
      viewD,
      UIStackView.stackable.space(after: viewD, 20), //Explicit custom space dependent on visibility of viewD. Equivalent to just using `20` here.
      viewE,
      UIStackView.stackable.space(before: viewF, 20), //Custom space before viewF. Dependent on the visibility of `viewF`
      viewF,
  ])
```

#### Flexible Spaces
```swift
  stack.stackable.add([
      viewA,
      20...30, // Flexible space, at least 20, at most 30, inclusive. Flexible spaces do not track view visibility.
      viewB,
      20..., // Flexible space. At least 20, no maximum.
      viewC,
      ...15.5, // Flexible space. At least 0, at most 15.5, floating point works too!
      viewD,
      UIStackView.stackable.flexibleSpace, // flexible space, at least 0, no maximum. Equivalent to `0...`
      viewE,
      UIStackView.stackable.flexibleSpace(.atLeast(20)), // flexible space, at least 20, no maximum. equivalent to `20...`
      viewF,
      UIStackView.stackable.flexibleSpace(.atMost(20)), // flexible space. at least 0, at most 20, equivalent to `...20`
      viewG,
      UIStackView.stackable.flexibleSpace(.range(10...20)), // flexible space, at least 10, at most 20, equivalent to `10...20`
  ])
```

#### Advanced Spaces
```swift
    let cells: [UIView] = ...
    stack.stackable.add([
        cells,
        UIStackView.stackable.space(afterGroup: cells, 20), // A space that is dependent on at least one view in `cells` to be visible.
    ])
```

## Hairlines

```swift
  stack.stackable.add([
      viewA,
      UIStackView.stackable.hairline, // Simple hairline, extended to edges of StackView. 
      viewB,
      UIStackView.stackable.hairline(after: viewB), // hairline that mirrors visibility of `viewB`
      viewC,
      UIStackView.stackable.hairline(between: viewC, viewD), // hairline that is dependent on both `viewC` and `viewD` being visible.
      viewD,
      UIStackView.stackable.hairline(before: viewE), // hairline before `viewE`, mirrors visibility of `viewE`
      viewE,
      viewF,
      UIStackView.stackable.hairlines(around: viewF), // hairline added above and below viewF. Mirrors visibility of `viewF`
   ])
```

#### Hairlines and Groups
```swift
  let cells: [UIView] = ...

  stack.stackable.add([
      cellsA,
      UIStackView.stackable.hairlines(between: cellsA), // Hairlines between any visibile members of `cellsA`
      
      cellsB,
      UIStackView.stackable.hairlines(after: cellsB), // Hairlines after all visible members of `cellsB`
      
      cellsC,
      UIStackView.stackable.hairlines(around: cellsC), // Hairlines above and below all visible members of `cellsC`
  ])
```

#### Hairline Alignment
```swift
  stack.stackable.add([
      viewA,
      UIStackView.hairline
        .inset(by: .init(top: 0, left: 10, bottom: 0, right: 10) // hairline inset horizontally by 10
        
      viewB,
      UIStackView.hairline
        .inset(by: .init(top: 0, left: -10, bottom: 0, right: -10) // hairline outset horizontally by 10

      viewC,
      UIStackView.hairline
        .outset(to: view) // hairline constrained to edges of some ancestor (horizontal edges for a vertical stack)
  ])
```

#### Hairline Appearance

Hairline appearance can be customized on a per hairline or group basis:
```swift
  stack.stackable.add([
    viewA,
    UIStackView.hairline
      .color(.lightGray)
      .thickness(1),
      
    cells,
    UIStackView.hairlines(around: cells)
        .color(.red)
        .thickness(10)
  ])
```

It can also be customized on a per `UIStackView` basis:
```swift
  let stack = UIStackView()
  stack.stackable.hairlineColor = .lightGray
  stack.stackable.hairlineThickness = 1
```

It can also be customized with a global default:
```swift
  UIStackView.stackable.hairlineColor = .lightGray
  UIStackView.stackable.hairlineThickness = 1
```

If more customiztion is required, you may provide a `HairlineProvider` to vend the `UIView` that should be used as a hairline:
```swift
  let stack = UIStackView()
  stack.stackable.hairlineProvider = { stackView in
    let customHairline = UIView()
    //...
    return customHairline
  }
  
  // global default provider
  UIStackView.stackable.hairlineProvider = { stackView in
    let customHairline = UIView()
    //...
    return customHairline
  }
```

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

Stackable is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'Stackable'
```

## Author

jclark@rightpoint.com

## License

Stackable is available under the MIT license. See the LICENSE file for more info.
