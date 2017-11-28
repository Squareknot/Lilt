//
//  Animator.swift
//  Lilt
//
//  Created by Jordan Kay on 9/6/15.
//  Copyright © 2015 Squareknot. All rights reserved.
//

class Animator<T: Animatable> {
    private let value: T
    private let initialValue: T
    private let duration: TimeInterval
    private let curve: AnimationCurve
    private let setter: (T) -> Void
    private let completion: (() -> Void)?
    
    private var displayLink: CADisplayLink!
    private var initialTimestamp: TimeInterval!
    
    init(value: T, initialValue: T, duration: TimeInterval, curve: AnimationCurve, setter: @escaping (T) -> Void, completion: (() -> Void)?) {
        self.value = value
        self.initialValue = initialValue
        self.duration = duration
        self.curve = curve
        self.setter = setter
        self.completion = completion
    }
    
    func animate() {
        displayLink = CADisplayLink(target: self, selector: #selector(Animator.update))
        displayLink.add(to: RunLoop.main, forMode: RunLoopMode.commonModes)
    }
    
    @objc private dynamic func update() {
        if initialTimestamp == nil { initialTimestamp = displayLink.timestamp }
        
        let delta = value - initialValue
        let elapsed = displayLink.timestamp - initialTimestamp
        let ratio = min(elapsed / duration, 1.0)
        setter(initialValue + curve.timingFunction.value(ratio) * delta)
        
        if ratio == 1.0 {
            displayLink.invalidate()
            displayLink = nil
            completion?()
        }
    }
}
