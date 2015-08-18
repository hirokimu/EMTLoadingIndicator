//
//  EMTLoadingIndicator.swift
//
//  Created by Hironobu Kimura on 2015/08/14.
//  Copyright (C) 2015 emotionale. All rights reserved.
//

import UIKit
import WatchKit
import CoreGraphics

@objc final public class EMTLoadingIndicator: NSObject {

    private weak var controller: WKInterfaceController?
    private weak var image: WKInterfaceImage?
    private var imageSize: CGSize
    
    public static var waitImage: UIImage?
    public static var progressImages = [UIImage]()
    public static var reloadImage: UIImage?

    public static var circleLineColor = UIColor.whiteColor()
    public static var progressLineColor = UIColor.whiteColor()
    public static var circleLineWidth: CGFloat = 1
    public static var progressLineWidth: CGFloat = 3
    
    private var currentProgressFrame: Int
    private var timer: EMTTimer?
    private var frames: Array<Int>
    private var isFirstProgressUpdate: Bool
    private var style: EMTLoadingIndicatorWaitStyle
    
    public init(interfaceController: WKInterfaceController?, interfaceImage: WKInterfaceImage?,
        width: CGFloat, height: CGFloat, style: EMTLoadingIndicatorWaitStyle) {
            
        self.controller = interfaceController
        self.image = interfaceImage
        self.imageSize = CGSize(width: width, height: height)
        self.style = style
        currentProgressFrame = 0
        frames = [Int]()
        image?.setAlpha(0)
        isFirstProgressUpdate = false
        
        super.init()
    }
    
    public func prepareImagesForWait() {
        if (style == .Dot) {
            prepareImagesForWaitStyleDot()
        } else if (style == .Line){
            prepareImagesForWaitStyleLine()
        }
    }
    
    private func prepareImagesForWaitStyleDot() {
        if EMTLoadingIndicator.reloadImage == nil {
            let bundle = NSBundle(forClass: EMTLoadingIndicator.self)
            let cursors: [UIImage] = (0...29).map {
                let index = $0
                return UIImage(contentsOfFile: (bundle.pathForResource("waitIndicatorGraphic-\(index)@2x", ofType: "png"))!)!
            }
            EMTLoadingIndicator.waitImage = UIImage.animatedImageWithImages(cursors, duration: 1)
        }
    }
    
    private func prepareImagesForWaitStyleLine() {
        if EMTLoadingIndicator.waitImage == nil {
        
            UIGraphicsBeginImageContextWithOptions(imageSize, false, 0)
            let context:CGContextRef = UIGraphicsGetCurrentContext()!
            
            let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: imageSize)
            let center = CGPoint(x: imageSize.width / 2, y: imageSize.height / 2)
            let radius = imageSize.width / 2 - EMTLoadingIndicator.circleLineWidth / 2
            
            let images: [UIImage] = (0...60).map {

                let degree = CGFloat(-90 + 6 * $0)
                let startDegree = CGFloat(M_PI / 180) * degree
                let endDegree = startDegree + CGFloat(M_PI * 2 * 0.9)
                
                let path:UIBezierPath = UIBezierPath(arcCenter: center,
                    radius: radius,
                    startAngle: startDegree,
                    endAngle: endDegree,
                    clockwise: true)
                path.lineWidth = EMTLoadingIndicator.circleLineWidth
                path.lineCapStyle = CGLineCap.Square
                path.lineJoinStyle = CGLineJoin.Miter
                EMTLoadingIndicator.circleLineColor.setStroke()
                path.stroke()
                
                let currentFrameImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()
                CGContextClearRect(context, rect)
                
                return currentFrameImage
            }
            
            UIGraphicsEndImageContext()
            
            EMTLoadingIndicator.waitImage = UIImage.animatedImageWithImages(images, duration: 1)
        }
    }
    
    public func prepareImagesForProgress() {
        if EMTLoadingIndicator.progressImages.count == 0 {

            UIGraphicsBeginImageContextWithOptions(imageSize, false, 0)
            let context:CGContextRef = UIGraphicsGetCurrentContext()!

            let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: imageSize)
            let center = CGPoint(x: imageSize.width / 2, y: imageSize.height / 2)
            let radius = imageSize.width / 2 - EMTLoadingIndicator.circleLineWidth / 2
            let progressRadius = radius - EMTLoadingIndicator.progressLineWidth / 2
            
            let images: [UIImage] = (0...60).map {

                let path:UIBezierPath = UIBezierPath(arcCenter: center,
                    radius: radius,
                    startAngle: 0,
                    endAngle: CGFloat(M_PI * 2),
                    clockwise: true)
                
                path.lineWidth = EMTLoadingIndicator.circleLineWidth
                path.lineCapStyle = CGLineCap.Round
                EMTLoadingIndicator.circleLineColor.setStroke()
                path.stroke()

                let degree: CGFloat = 6 * CGFloat($0)
                let startDegree = CGFloat(-M_PI / 2)
                let endDegree = startDegree + CGFloat(M_PI / 180) * degree
                
                let progressPath:UIBezierPath = UIBezierPath(arcCenter: center,
                    radius: progressRadius,
                    startAngle: startDegree,
                    endAngle: endDegree,
                    clockwise: true)
                progressPath.lineWidth = EMTLoadingIndicator.progressLineWidth
                progressPath.lineCapStyle = CGLineCap.Butt
                EMTLoadingIndicator.progressLineColor.setStroke()
                progressPath.stroke()
                
                let currentFrameImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()
                CGContextClearRect(context, rect)
                
                return currentFrameImage
            }
            
            UIGraphicsEndImageContext()
            
            EMTLoadingIndicator.progressImages = images
        }
    }
    
    public func prepareImagesForReload() {
        if EMTLoadingIndicator.reloadImage == nil {
            
            UIGraphicsBeginImageContextWithOptions(imageSize, false, 0)
            let context:CGContextRef = UIGraphicsGetCurrentContext()!

            let triangleSideLength = EMTLoadingIndicator.circleLineWidth * 6
            let center = CGPointMake(imageSize.width / 2, imageSize.height / 2)
            let radius = imageSize.width / 2 - triangleSideLength / 2
            let startDegree: CGFloat = 0
            let endDegree = startDegree + CGFloat(M_PI * 1.5)
            
            let path:UIBezierPath = UIBezierPath(arcCenter: center,
                radius: radius,
                startAngle: startDegree,
                endAngle: endDegree,
                clockwise: true)
            path.lineWidth = EMTLoadingIndicator.circleLineWidth
            path.lineCapStyle = CGLineCap.Square
            path.lineJoinStyle = CGLineJoin.Miter
            EMTLoadingIndicator.circleLineColor.setStroke()
            path.stroke()
            
            CGContextSetFillColorWithColor(context, EMTLoadingIndicator.circleLineColor.CGColor)
            CGContextMoveToPoint(context, center.x, 0)
            CGContextAddLineToPoint(context, center.x + triangleSideLength * 0.866, triangleSideLength / 2)
            CGContextAddLineToPoint(context, center.x, triangleSideLength)
            CGContextClosePath(context)
            CGContextFillPath(context)
            
            EMTLoadingIndicator.reloadImage = UIGraphicsGetImageFromCurrentImageContext()
            
            UIGraphicsEndImageContext()
        }
    }

    public func showWait() {
        prepareImagesForWait()
        image?.setImage(EMTLoadingIndicator.waitImage)
        image?.startAnimating()
        
        if let controller = controller, image = image {
            controller.animateWithDuration(0.3, animations: {
                image.setAlpha(1)
            })
        } else {
            image?.setAlpha(1)
        }
    }
    
    public func showReload() {
        prepareImagesForReload()
        image?.stopAnimating()
        image?.setImage(EMTLoadingIndicator.reloadImage)
        
        if let controller = controller, image = image {
            controller.animateWithDuration(0.3, animations: {
                image.setAlpha(1)
            })
        } else {
            image?.setAlpha(1)
        }
    }
    
    public func showProgress(startPercentage startPercentage: Float) {
        prepareImagesForProgress()
        image?.setImage(nil)
        currentProgressFrame = 0
        isFirstProgressUpdate = true

        let startFrame = getCurrentFrameIndex(startPercentage)
        setProgressImage(startFrame)
        
        if let controller = controller, image = image {
            controller.animateWithDuration(0.3, animations: {
                image.setAlpha(1)
            })
        } else {
            image?.setAlpha(1)
        }
    }

    public func updateProgress(percentage percentage: Float) {

        let toFrame = getCurrentFrameIndex(percentage)
        
        frames.removeAll()
        frames = (1...10).map {
            var t = 0.3 / 10 * Float($0)
            let b = Float(currentProgressFrame)
            let c = Float(toFrame) - b
            let d: Float = 0.3
            t /= d
            return Int(b - c * t * (t - 2))
        }
        
        clearTimer()
        timer = EMTTimer(
                    interval: 0.033,
                    callback: { [weak self] (timer: NSTimer) in
                        if let weakSelf = self {
                            weakSelf.nextFrame(timer)
                        }
                    },
                    userInfo: nil,
                    repeats: true)
        updateProgressImage()
    }
    
    public func nextFrame(timer: NSTimer) {
        updateProgressImage()
    }
    
    public func updateProgressImage() {
        let toFrame = frames[0]
        setProgressImage(toFrame)
        
        frames.removeAtIndex(0)
        if frames.count == 0 {
            clearTimer()
        }
    }

    private func clearTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    private func setProgressImage(toFrame: Int) {
        if !isFirstProgressUpdate && currentProgressFrame == toFrame {
            return
        }
        isFirstProgressUpdate = false
        currentProgressFrame = toFrame
        image?.setImage(EMTLoadingIndicator.progressImages[currentProgressFrame])
    }
    
    public func hide() {
        image?.stopAnimating()
        
        if let controller = controller, image = image {
            controller.animateWithDuration(0.3, animations: {
                image.setAlpha(0)
            })
        } else {
            image?.setAlpha(0)
        }
    }
    
    private func getCurrentFrameIndex(forPercentage: Float) -> Int {
        if (forPercentage < 0) {
           return 0
        } else if (forPercentage > 100) {
           return 60
        }
        return Int(60.0 * forPercentage / 100.0)
    }

    public func clearWaitImage() {
        EMTLoadingIndicator.waitImage = nil
    }
    
    public func clearReloadImage() {
        EMTLoadingIndicator.reloadImage = nil
    }
    
    public func clearProgressImage() {
        EMTLoadingIndicator.progressImages.removeAll()
    }
    
    deinit {
        clearTimer()
        image?.stopAnimating()
    }
}

@objc public enum EMTLoadingIndicatorWaitStyle: Int {
    case Dot
    case Line
}
