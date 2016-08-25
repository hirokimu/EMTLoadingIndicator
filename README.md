#EMTLoadingIndicator
Displays loading indicator on Apple watchOS 2+

## Installation
Simply add class and resource files to your project, or use CocoaPods.

### Podfile

```ruby
use_frameworks!
target :'SomeWatchKitApp Extension', :exclusive => true do
	platform :watchos, '2.0'
    pod 'EMTLoadingIndicator', '~> 1.0.7'
end
```

## Usage

### Initialization

```swift

private var indicator: EMTLoadingIndicator?

override func willActivate() {

    indicator = EMTLoadingIndicator(interfaceController: self, interfaceImage: image!, 
        width: 40, height: 40, style: .Line)
```

width and height are the size of WKInterfaceImage passed to 2nd argument. Indicator images will be created with this size.
Style argument decides the visual of wait (loop) indicator - Dot or Line.


### Dot (System-like) Indicator

![Image](http://www.emotionale.jp/images/git/loadingindicator/img0.jpg)

```swift
indicator = EMTLoadingIndicator(interfaceController: self, interfaceImage: image!, 
    width: 40, height: 40, style: .Dot)

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
    width: 40, height: 40, style: .Line)
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
EMTLoadingIndicator.reloadColor = UIColor.whiteColor()
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
- watchOS 2.0+

## License
EMTLoadingIndicator is available under the MIT license. See the LICENSE file for more info.
