//
//  EMTTimer.swift
//
//  Created by Hironobu Kimura on 2016/08/04.
//  Copyright (C) 2016 emotionale. All rights reserved.
//

import WatchKit

typealias EMTTimerCallback = (Timer) -> Void

public final class EMTTimer: NSObject {
    
    private var timer: EMTTimerInternal?
    private var callback: EMTTimerCallback
    
    init(interval: TimeInterval, callback: @escaping EMTTimerCallback, userInfo: AnyObject?, repeats: Bool) {
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

    private var timer: Timer?
    private var callback: (Timer) -> Void
    
    init(interval: TimeInterval, callback: @escaping EMTTimerCallback, userInfo: AnyObject?, repeats: Bool) {

        self.callback = callback
        
        super.init()
        
        self.timer = Timer.scheduledTimer(timeInterval: interval,
                                          target: self,
                                          selector: repeats ? #selector(repeatTimerFired(timer:)) : #selector(timerFired(timer:)),
                                          userInfo: userInfo,
                                          repeats: repeats)
    }

    @objc func repeatTimerFired(timer: Timer) {
        self.callback(timer)
    }

    @objc func timerFired(timer: Timer) {
        self.callback(timer)
        timer.invalidate()
    }

    func invalidate() {
        timer?.invalidate()
    }
}
