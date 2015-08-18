#EMTLoadingIndicator
Displays loading indicator on Apple watchOS 2

## Installation
Simply add class and resource files to your project, or use CocoaPods.

### Podfile

```ruby
platform :ios, "9.0"
target :'Your WatchKit Extension Name', :exclusive => true do
    pod 'EMTLoadingIndicator', '~> 1.0.0'
end
```

## Usage

### Initialization

```swift

private var indicator: EMTLoadingIndicator?

override func willActivate() {

    indicator = EMTLoadingIndicator(interfaceController:self, interfaceImage:self.image, 
        width:40, height:40, style: EMTLoadingIndicatorWaitStyle.Line)
```

width and height are the size of WKInterfaceImage passed to 2nd argument. Indicator images will be created with this size.
style decides the visual of wait (loop) indicator - Dot or Circular.

### Dot (Default-look) Indicator

![Image](http://www.emotionale.jp/images/git/loadingindicator/img0.jpg)

```swift
indicator = EMTLoadingIndicator(interfaceController:self, interfaceImage:self.image, 
    width:40, height:40, style:EMTLoadingIndicatorWaitStyle.Dot);

// prepareImageForWait will be called via showWait automatically at the first time.
// You can also call it in your timing if necessary.
indicator?.prepareImagesForWait()

// show
indicator?.showWait()

// hide
indicator?.hide()
```
*Images of Dot indicator are static resource files size of 80px x 80px. These are stored in waitIndicatorGraphic.bundle.
 PNG files in that bundle are created with Flash CC (waitIndicatorGraphic.fla).


### Circular Indicator

![Image](http://www.emotionale.jp/images/git/loadingindicator/img1.jpg)

```swift
indicator = EMTLoadingIndicator(interfaceController:self, interfaceImage:self.image, 
    width:40, height:40, style:EMTLoadingIndicatorWaitStyle.Line);
indicator?.prepareImagesForWait()
indicator?.showWait()
indicator?.hide()
```

### Progress Indicator

![Image](http://www.emotionale.jp/images/git/loadingindicator/img2.jpg)

```swift
indicator?.prepareImagesForProgress()

// You can set start percentage other than 0.
indicator?.showProgress(startPercentage:0)

// Update progress percentage with animation
indicator?.updateProgress(percentage:75)

indicator?.hide()
```

### Reload Icon

![Image](http://www.emotionale.jp/images/git/loadingindicator/img3.jpg)

You can display static reload icon (for some loading error situation).

```swift
indicator?.showReload()
```

### Styling

You can change color and line width of Circular/Progress indicator.
You need to set properties before using prepare/show methods.

```swift
EMTLoadingIndicator.circleLineColor = UIColor.blueColor() // default: white
EMTLoadingIndicator.circleLineWidth = 2 // default: 1
EMTLoadingIndicator.progressLineColor = UIColor.redColor() // default: white
EMTLoadingIndicator.progressLineWidth = 8 // default: 4
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
- iOS 9.0+

## License
EMTLoadingIndicator is available under the MIT license. See the LICENSE file for more info.

## Notice
All images in this readme are fakes created with Photoshop. Not screenshots.
