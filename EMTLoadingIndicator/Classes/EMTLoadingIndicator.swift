//
//  EMTLoadingIndicator.swift
//
//  Created by Hironobu Kimura on 2016/08/04.
//  Copyright (C) 2016 emotionale. All rights reserved.
//

import UIKit
import WatchKit

@objc
final public class EMTLoadingIndicator: NSObject {

    private weak var controller: WKInterfaceController?
    private weak var image: WKInterfaceImage?
    private var imageSize: CGSize
    
    private static var dotWaitImage: UIImage?
    private static var lineWaitImage: UIImage?
    private static var progressImages = [UIImage]()
    private static var reloadImage: UIImage?

    public static var circleLineWidth: CGFloat = 1
    public static var circleLineColor = UIColor(white: 1, alpha: 0.8)

    public static var progressLineWidthOuter: CGFloat = 1
    public static var progressLineWidthInner: CGFloat = 2
    public static var progressLineColorOuter = UIColor(white: 1, alpha: 0.28)
    public static var progressLineColorInner = UIColor(white: 1, alpha: 0.70)
    
    public static var reloadLineWidth: CGFloat = 4
    public static var reloadArrowRatio: CGFloat = 3
    public static var reloadColor = UIColor.white
    
    private var currentProgressFrame = 0
    private var timer: EMTTimer?
    private var frames = [Int]()
    private var isFirstProgressUpdate = false
    private var style: EMTLoadingIndicatorWaitStyle
    
    public init(interfaceController: WKInterfaceController?, interfaceImage: WKInterfaceImage?,
        width: CGFloat, height: CGFloat, style: EMTLoadingIndicatorWaitStyle) {
            
        controller = interfaceController
        image = interfaceImage
        imageSize = CGSize(width: width, height: height)
        self.style = style
        image?.setAlpha(0)
        
        super.init()
    }
    
    public func prepareImagesForWait() {
        if style == .dot {
            prepareImagesForWaitStyleDot()
        }
        else if style == .line {
            prepareImagesForWaitStyleLine()
        }
    }
    
    private func prepareImagesForWaitStyleDot() {
        if EMTLoadingIndicator.dotWaitImage == nil {
            let bundle = Bundle(for: EMTLoadingIndicator.self)
            let cursors: [UIImage] = (0...29).map {
                let index = $0
                return UIImage(contentsOfFile: (bundle.path(forResource: "waitIndicatorGraphic-\(index)@2x", ofType: "png"))!)!
            }
            EMTLoadingIndicator.dotWaitImage = UIImage.animatedImage(with: cursors, duration: 1)
        }
    }
    
    private func prepareImagesForWaitStyleLine() {
        if EMTLoadingIndicator.lineWaitImage == nil {
            UIGraphicsBeginImageContextWithOptions(imageSize, false, 0)
            let context = UIGraphicsGetCurrentContext()!
            
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
                path.lineCapStyle = CGLineCap.square
                path.lineJoinStyle = CGLineJoin.miter
                EMTLoadingIndicator.circleLineColor.setStroke()
                path.stroke()
                
                let currentFrameImage = UIGraphicsGetImageFromCurrentImageContext()
                context.clear(rect)
                
                return currentFrameImage!
            }
            UIGraphicsEndImageContext()
            
            EMTLoadingIndicator.lineWaitImage = UIImage.animatedImage(with: images, duration: 1)
        }
    }
    
    public func prepareImagesForProgress() {
        if EMTLoadingIndicator.progressImages.count == 0 {
            UIGraphicsBeginImageContextWithOptions(imageSize, false, 0)
            let context = UIGraphicsGetCurrentContext()!

            let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: imageSize)
            let center = CGPoint(x: imageSize.width / 2, y: imageSize.height / 2)
            let radius = imageSize.width / 2 - EMTLoadingIndicator.progressLineWidthOuter / 2
            let progressRadius = radius - EMTLoadingIndicator.progressLineWidthInner / 2
            
            let images: [UIImage] = (0...60).map {

                let path = UIBezierPath(arcCenter: center,
                    radius: radius,
                    startAngle: 0,
                    endAngle: CGFloat(M_PI * 2),
                    clockwise: true)
                
                path.lineWidth = EMTLoadingIndicator.progressLineWidthOuter
                path.lineCapStyle = CGLineCap.round
                EMTLoadingIndicator.progressLineColorOuter.setStroke()
                path.stroke()

                let degree = 6 * CGFloat($0)
                let startDegree = CGFloat(-M_PI / 2)
                let endDegree = startDegree + CGFloat(M_PI / 180) * degree
                
                let progressPath:UIBezierPath = UIBezierPath(arcCenter: center,
                                                             radius: progressRadius,
                                                             startAngle: startDegree,
                                                             endAngle: endDegree,
                                                             clockwise: true)
                progressPath.lineWidth = EMTLoadingIndicator.progressLineWidthInner
                progressPath.lineCapStyle = CGLineCap.butt
                EMTLoadingIndicator.progressLineColorInner.setStroke()
                progressPath.stroke()
                
                let currentFrameImage = UIGraphicsGetImageFromCurrentImageContext()
                context.clear(rect)
                
                return currentFrameImage!
            }
            UIGraphicsEndImageContext()
            
            EMTLoadingIndicator.progressImages = images
        }
    }
    
    public func prepareImagesForReload() {
        if EMTLoadingIndicator.reloadImage == nil {
            UIGraphicsBeginImageContextWithOptions(imageSize, false, 0)
            let context = UIGraphicsGetCurrentContext()!

            let triangleSideLength = EMTLoadingIndicator.reloadLineWidth * EMTLoadingIndicator.reloadArrowRatio
            let center = CGPoint(x: imageSize.width / 2, y: imageSize.height / 2)
            let radius = imageSize.width / 2 - triangleSideLength / 2
            let startDegree: CGFloat = 0
            let endDegree = startDegree + CGFloat(M_PI * 1.5)
            
            let path:UIBezierPath = UIBezierPath(arcCenter: center,
                                                 radius: radius,
                                                 startAngle: startDegree,
                                                 endAngle: endDegree,
                                                 clockwise: true)
            path.lineWidth = EMTLoadingIndicator.reloadLineWidth
            path.lineCapStyle = CGLineCap.square
            path.lineJoinStyle = CGLineJoin.miter
            EMTLoadingIndicator.reloadColor.setStroke()
            path.stroke()
            
            context.setFillColor(EMTLoadingIndicator.reloadColor.cgColor)
            context.move(to: CGPoint(x: center.x, y: 0))
            context.addLine(to: CGPoint(x: center.x + triangleSideLength * 0.866, y: triangleSideLength / 2))
            context.addLine(to: CGPoint(x: center.x, y: triangleSideLength))
            context.closePath()
            context.fillPath()
            
            EMTLoadingIndicator.reloadImage = UIGraphicsGetImageFromCurrentImageContext()
            
            UIGraphicsEndImageContext()
        }
    }

    public func showWait() {
        prepareImagesForWait()

        image?.setImage(style == .dot ? EMTLoadingIndicator.dotWaitImage : EMTLoadingIndicator.lineWaitImage)
        image?.startAnimating()
        
        if let controller = controller, let image = image {
            controller.animate(withDuration: 0.3, animations: {
                image.setAlpha(1)
            })
        }
        else {
            image?.setAlpha(1)
        }
    }
    
    public func showReload() {
        prepareImagesForReload()
        image?.stopAnimating()
        image?.setImage(EMTLoadingIndicator.reloadImage)
        
        if let controller = controller, let image = image {
            controller.animate(withDuration: 0.3, animations: {
                image.setAlpha(1)
            })
        }
        else {
            image?.setAlpha(1)
        }
    }
    
    public func showProgress(startPercentage: Float) {
        prepareImagesForProgress()
        image?.setImage(nil)
        currentProgressFrame = 0
        isFirstProgressUpdate = true

        let startFrame = getCurrentFrameIndex(forPercentage: startPercentage)
        setProgressImage(toFrame: startFrame)
        
        if let controller = controller, let image = image {
            controller.animate(withDuration: 0.3, animations: {
                image.setAlpha(1)
            })
        }
        else {
            image?.setAlpha(1)
        }
    }

    public func updateProgress(percentage: Float) {

        let toFrame = getCurrentFrameIndex(forPercentage: percentage)
        
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
                    callback: { [weak self] timer in
                        self?.nextFrame(timer: timer)
                    },
                    userInfo: nil,
                    repeats: true)
        updateProgressImage()
    }
    
    public func nextFrame(timer: Timer) {
        updateProgressImage()
    }
    
    public func updateProgressImage() {
        let toFrame = frames[0]
        setProgressImage(toFrame: toFrame)
        
        frames.remove(at: 0)
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
        
        if let controller = controller, let image = image {
            controller.animate(withDuration: 0.3, animations: {
                image.setAlpha(0)
            })
        }
        else {
            image?.setAlpha(0)
        }
    }
    
    private func getCurrentFrameIndex(forPercentage: Float) -> Int {
        if forPercentage < 0 {
           return 0
        }
        else if forPercentage > 100 {
           return 60
        }
        return Int(60.0 * forPercentage / 100.0)
    }

    public func clearWaitImage(type: EMTLoadingIndicatorWaitStyle) {
        if style == .dot {
            EMTLoadingIndicator.dotWaitImage = nil
        }
        else if style == .line {
            EMTLoadingIndicator.lineWaitImage = nil
        }
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

@objc
public enum EMTLoadingIndicatorWaitStyle: Int {
    case dot
    case line
}
