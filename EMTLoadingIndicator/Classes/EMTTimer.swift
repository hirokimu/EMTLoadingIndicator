//
//  EMTTimer.swift
//
//  Created by Hironobu Kimura on 2015/08/17.
//  Copyright (C) 2015 emotionale. All rights reserved.
//

import WatchKit

public final class EMTTimer: NSObject {

    private var timer: EMTTimerInternal?
    private var callback: (NSTimer) -> Void
    
    init(interval: NSTimeInterval, callback: (NSTimer) -> Void, userInfo: AnyObject?, repeats: Bool) {
        self.callback = callback
        super.init()
        timer = EMTTimerInternal(
                    interval: interval,
                    callback: { [weak self] (timer: NSTimer) in
                        if let weakSelf = self {
                            weakSelf.callback(timer)
                        }
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
    
    init(interval: NSTimeInterval, callback: (NSTimer) -> Void, userInfo: AnyObject?, repeats: Bool) {

        self.callback = callback
        
        super.init()
        
        self.timer = NSTimer.scheduledTimerWithTimeInterval(
                        interval,
                        target: self,
                        selector: (repeats) ? "repeatTimerFired:" : "timerFired:",
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
