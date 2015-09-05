//
//  Animation.swift
//  Lilt
//
//  Created by Jordan Kay on 9/5/15.
//  Copyright © 2015 jordanekay. All rights reserved.
//

public func animateWithDuration(duration: NSTimeInterval, curve: AnimationCurve, animations: () -> Void) {
    animateWithDuration(duration, curve: curve, animations: animations, completion: nil)
}

public func animateWithDuration(duration: NSTimeInterval, curve: AnimationCurve, animations: () -> Void, completion: (() -> Void)?) {
    CATransaction.begin()
    CATransaction.setAnimationDuration(duration)
    CATransaction.setAnimationTimingFunction(curve.timingFunction)
    CATransaction.setCompletionBlock(completion)
    UIView.animateWithDuration(duration, animations: animations)
    CATransaction.commit()
}

extension UIView {
    public func animateProperty<T: Animatable>(property: T, toValue value: T, withDuration duration: NSTimeInterval, curve: AnimationCurve = AnimationCurve(ease: .InOut), setter: T -> Void) {
        let animator = Animator(value: value, initialValue: property, duration: duration, curve: curve, setter: setter)
        animator.animate()
    }
}
