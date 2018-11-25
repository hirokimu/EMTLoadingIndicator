# EMTLoadingIndicator
Displays loading indicator on Apple watchOS 4+

[![License](https://img.shields.io/badge/license-MIT-blue.svg?style=flat
            )](http://mit-license.org) [![Platform](https://img.shields.io/badge/platform-watchOS-lightgrey.svg?style=flat
             )](https://developer.apple.com/resources/) [![Language](https://img.shields.io/badge/language-swift-orange.svg?style=flat
             )](https://developer.apple.com/swift) [![Cocoapod](https://img.shields.io/cocoapods/v/EMTLoadingIndicator.svg?style=flat)](http://cocoadocs.org/docsets/EMTLoadingIndicator/)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

## Installation
Simply add class and resource files to your project, or use CocoaPods or Carthage.

### Podfile

```ruby
use_frameworks!
target :'SomeWatchKitApp Extension', :exclusive => true do
	platform :watchos, '4.0'
    pod 'EMTLoadingIndicator', '~> 4.0.0'
end
```

### Carthage

```
carthage update --platform watchOS
```

## Usage

### Initialization

```swift

private var indicator: EMTLoadingIndicator?

override func willActivate() {

    indicator = EMTLoadingIndicator(interfaceController: self, interfaceImage: image!,
        width: 40, height: 40, style: .line)
```

width and height are the size of WKInterfaceImage passed to 2nd argument. Indicator images will be created with this size.
Style argument decides the visual of wait (loop) indicator - Dot or Line.


### Dot Indicator

![Image](http://www.emotionale.jp/images/git/loadingindicator/img0.jpg)

```swift
indicator = EMTLoadingIndicator(interfaceController: self, interfaceImage: image!,
    width: 40, height: 40, style: .dot)

// prepareImageForWait will be called automatically in the showWait method at the first time.
// It takes a bit of time. You can call it manually if necessary.
indicator?.prepareImagesForWait()

// show
indicator?.showWait()

// hide
indicator?.hide()
```
*Images of Dot indicator are static resource files size of 80px x 80px.
 These PNG files are created with Flash CC (waitIndicatorGraphic.fla).


### Line (Circular) Indicator

![Image](http://www.emotionale.jp/images/git/loadingindicator/img1.jpg)

```swift
indicator = EMTLoadingIndicator(interfaceController: self, interfaceImage: image!,
    width: 40, height: 40, style: .line)
indicator?.showWait()
indicator?.hide()
```

### Progress Indicator

![Image](http://www.emotionale.jp/images/git/loadingindicator/img2.jpg)

```swift
indicator?.prepareImagesForProgress()

// You can set start percentage other than 0.
indicator?.showProgress(startPercentage: 0)

// Update progress percentage with animation
indicator?.updateProgress(percentage: 75)

indicator?.hide()
```

### Reload Icon

![Image](http://www.emotionale.jp/images/git/loadingindicator/img3.jpg)

You can display static reload icon (in some loading error situations).

```swift
indicator?.showReload()
```

### Styling

If you want to change styles, you need to set properties before using prepare/show methods.

```swift
// defaults
EMTLoadingIndicator.circleLineColor = UIColor(white: 1, alpha: 0.8)
EMTLoadingIndicator.circleLineWidth = 1
EMTLoadingIndicator.progressLineColorOuter = UIColor(white: 1, alpha: 0.28)
EMTLoadingIndicator.progressLineColorInner = UIColor(white: 1, alpha: 0.70)
EMTLoadingIndicator.progressLineWidthOuter = 1
EMTLoadingIndicator.progressLineWidthInner = 2
EMTLoadingIndicator.reloadColor = UIColor.white
EMTLoadingIndicator.reloadLineWidth = 4
EMTLoadingIndicator.reloadArrowRatio = 3
```

### Clear Images

All created images are stored in static properties and used for all instances.
If you want to clear them, use following methods.

```swift
indicator?.clearWaitImage()
indicator?.clearReloadImage()
indicator?.clearProgressImage()
```

## Requirements
- watchOS 3.0+

## License
EMTLoadingIndicator is available under the MIT license. See the LICENSE file for more info.
