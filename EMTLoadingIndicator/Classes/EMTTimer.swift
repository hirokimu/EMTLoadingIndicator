//
//  EMTTimer.swift
//
//  Created by Hironobu Kimura on 2016/08/04.
//  Copyright (C) 2016 emotionale. All rights reserved.
//

import WatchKit

typealias EMTTimerCallback = (NSTimer) -> Void

public final class EMTTimer: NSObject {
    
    private var timer: EMTTimerInternal?
    private var callback: EMTTimerCallback
    
    init(interval: NSTimeInterval, callback: EMTTimerCallback, userInfo: AnyObject?, repeats: Bool) {
        self.callback = callback
        super.init()
        timer = EMTTimerInternal(
                    interval: interval,
                    callback: { [weak self] timer in
                        self?.callback(timer)
                    },
                    userInfo: userInfo,
                    repeats: repeats)
    }

    func invalidate() {
        timer?.invalidate()
    }
    
    deinit {
        timer?.invalidate()
    }
}

internal class EMTTimerInternal: NSObject {

    private var timer: NSTimer?
    private var callback: (NSTimer) -> Void
    
    init(interval: NSTimeInterval, callback: EMTTimerCallback, userInfo: AnyObject?, repeats: Bool) {

        self.callback = callback
        
        super.init()
        
        self.timer = NSTimer.scheduledTimerWithTimeInterval(
                        interval,
                        target: self,
                        selector: repeats ? #selector(repeatTimerFired(_:)) : #selector(timerFired(_:)),
                        userInfo: userInfo,
                        repeats: repeats)
    }

    func repeatTimerFired(timer: NSTimer) {
        self.callback(timer)
    }

    func timerFired(timer: NSTimer) {
        self.callback(timer)
        timer.invalidate()
    }

    func invalidate() {
        timer?.invalidate()
    }
}
