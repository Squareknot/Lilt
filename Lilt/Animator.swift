//
//  Animator.swift
//  Lilt
//
//  Created by Jordan Kay on 9/6/15.
//  Copyright © 2015 jordanekay. All rights reserved.
//

class Animator<T: Animatable> {
    private let value: T
    private let initialValue: T
    private let duration: NSTimeInterval
    private let curve: AnimationCurve
    private let setter: T -> Void
    
    private var displayLink: CADisplayLink!
    private var initialTimestamp: NSTimeInterval!
    
    init(value: T, initialValue: T, duration: NSTimeInterval, curve: AnimationCurve, setter: T -> Void) {
        self.value = value
        self.initialValue = initialValue
        self.duration = duration
        self.curve = curve
        self.setter = setter
    }
    
    func animate() {
        displayLink = CADisplayLink(target: self, selector: "update")
        displayLink.addToRunLoop(NSRunLoop.mainRunLoop(), forMode: NSRunLoopCommonModes)
    }
    
    private dynamic func update() {
        if initialTimestamp == nil { initialTimestamp = displayLink.timestamp }
        
        let ratio = min((displayLink.timestamp - initialTimestamp) / duration, 1.0)
        setter(initialValue + curve.timingFunction.value(ratio) * (value - initialValue))
        
        if ratio == 1.0 {
            displayLink.invalidate()
            displayLink = nil
        }
    }
}

extension CAMediaTimingFunction {
    private func point(i: Int) -> Double {
        let values = UnsafeMutablePointer<Float>.alloc(2)
        self.getControlPointAtIndex(i, values: values)
        let p = Double(values[1])
        values.dealloc(2)
        return p
    }
    
    private func value(t: Double) -> Double {
        let a = pow(1 - t, 3) * point(0)
        let b = 3 * pow(1 - t, 2) * t * point(1)
        let c = 3 * (1 - t) * pow(t, 2) * point(2)
        let d = pow(t, 3) * point(3)
        return a + b + c + d
    }
}
