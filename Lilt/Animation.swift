//
//  Animation.swift
//  Lilt
//
//  Created by Jordan Kay on 9/5/15.
//  Copyright © 2015 Squareknot. All rights reserved.
//

private var animatedViews = Set<UIView>()

public protocol AnimatableView {
    associatedtype T = Self
    
    func animate(if animated: Bool, withDuration duration: TimeInterval, curve: Lilt.AnimationCurve, beginsFromCurrentState: Bool, animations: (T) -> Void)
    func animate(if animated: Bool, withDuration duration: TimeInterval, curve: Lilt.AnimationCurve, beginsFromCurrentState: Bool, animations: (T) -> Void, completion: (() -> Void)?)
    func animateOrganically(if animated: Bool, withDuration duration: TimeInterval, animations: @escaping (T) -> Void)
    func animateOrganically(if animated: Bool, withDuration duration: TimeInterval, animations: @escaping (T) -> Void, completion: (() -> Void)?)
    func crossfade(if animated: Bool, withDuration duration: TimeInterval, animations: @escaping (T) -> Void)
    func crossfade(if animated: Bool, withDuration duration: TimeInterval, animations: @escaping (T) -> Void, completion: (() -> Void)?)
}

public extension AnimatableView where Self: UIView {
    func animate(if animated: Bool = true, withDuration duration: TimeInterval = .defaultDuration, curve: Lilt.AnimationCurve = .init(ease: .inOut), beginsFromCurrentState: Bool = true, animations: (Self) -> Void) {
        animate(if: animated, withDuration: duration, curve: curve, beginsFromCurrentState: beginsFromCurrentState, animations: animations, completion: nil)
    }
    
    func animate(if animated: Bool = true, withDuration duration: TimeInterval = .defaultDuration, curve: Lilt.AnimationCurve = .init(ease: .inOut), beginsFromCurrentState: Bool = true, animations: (Self) -> Void, completion: (() -> Void)?) {
        if animated {
            Lilt.animate(view: self, withDuration: duration, curve: curve, beginsFromCurrentState: beginsFromCurrentState, animations: { animations(self) }, completion: completion)
        } else {
            animations(self)
        }
    }
    
    func animateOrganically(if animated: Bool = true, withDuration duration: TimeInterval = .defaultDuration, animations: @escaping (Self) -> Void) {
        animateOrganically(if: animated, withDuration: duration, animations: animations, completion: nil)
    }

    func animateOrganically(if animated: Bool = true, withDuration duration: TimeInterval = .defaultDuration, animations: @escaping (Self) -> Void, completion: (() -> Void)?) {
        if animated{
            Lilt.animateOrganically(view: self, duration: duration, animations: { animations(self) }, completion: completion)
        } else {
            animations(self)
        }
    }

    func crossfade(if animated: Bool = true, withDuration duration: TimeInterval = .defaultDuration, animations: @escaping (Self) -> Void) {
        crossfade(if: animated, withDuration: duration, animations: animations, completion: nil)
    }

    func crossfade(if animated: Bool = true, withDuration duration: TimeInterval = .defaultDuration, animations: @escaping (Self) -> Void, completion: (() -> Void)?) {
        if animated {
            UIView.transition(with: self, duration: duration, options: .transitionCrossDissolve, animations: { animations(self) }) { _ in
                completion?()
            }
        } else {
            animations(self)
        }
    }
}

extension UIView: AnimatableView {}

public extension UIView {
    var animatedScale: CGAffineTransform {
        let transform = layer.presentation()!.transform
        return transform.scale
    }
    
    fileprivate(set) var isAnimating: Bool {
        get {
            return animatedViews.contains(self)
        }
        set {
            if newValue {
                animatedViews.insert(self)
            } else {
                animatedViews.remove(self)
            }
        }
    }
    
    func animateProperty<T: Animatable>(_ property: T, toValue value: T, withDuration duration: TimeInterval = .defaultDuration, curve: Lilt.AnimationCurve = .init(ease: .inOut), setter: @escaping (T) -> Void) {
        animateProperty(property, toValue: value, withDuration: duration, curve: curve, setter: setter, completion: nil)
    }
    
    func animateProperty<T: Animatable>(_ property: T, toValue value: T, withDuration duration: TimeInterval = .defaultDuration, curve: Lilt.AnimationCurve = .init(ease: .inOut), setter: @escaping (T) -> Void, completion: (() -> Void)? = nil) {
        let animator = Animator(value: value, initialValue: property, duration: duration, curve: curve, setter: setter) {
            self.endAnimation(withCompletion: completion)
        }
        startAnimation()
        animator.animate()
    }
}

public extension CABasicAnimation {
    convenience init(cornerRadius: CGFloat) {
        self.init(keyPath: "cornerRadius")
        fromValue = cornerRadius
    }
    
    convenience init(shadowPath: CGPath) {
        self.init(keyPath: "shadowPath")
        fromValue = shadowPath
    }
}

public extension CAMediaTimingFunction {
    convenience init(timingParameters: UICubicTimingParameters) {
        let controlPoint1 = timingParameters.controlPoint1
        let controlPoint2 = timingParameters.controlPoint2
        self.init(controlPoints: Float(controlPoint1.x), Float(controlPoint1.y), Float(controlPoint2.x), Float(controlPoint2.y))
    }
}

private func animateOrganically(view: UIView?, duration: TimeInterval = .defaultDuration, animations: @escaping () -> Void, completion: (() -> Void)? = nil) {
    let finish = {
        if let view = view {
            view.endAnimation(withCompletion: completion)
        } else {
            completion?()
        }
    }

    view?.startAnimation()
    UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: organicSpringDamping, initialSpringVelocity: 0, options: .curveLinear, animations: animations) { _ in
        finish()
    }
}

private func animate(view: UIView?, withDuration duration: TimeInterval = .defaultDuration, curve: Lilt.AnimationCurve, beginsFromCurrentState: Bool, animations: () -> Void, completion: (() -> Void)?) {
    let finish = {
        if let view = view {
            view.endAnimation(withCompletion: completion)
        } else {
            completion?()
        }
    }
    if let timingFunction = curve.timingFunction as? CAMediaTimingFunction {
        view?.startAnimation()
        CATransaction.begin()
        CATransaction.setAnimationTimingFunction(timingFunction)
        CATransaction.setCompletionBlock(finish)
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(duration)
        UIView.setAnimationBeginsFromCurrentState(beginsFromCurrentState)
        animations()
        UIView.commitAnimations()
        CATransaction.commit()
    }
}

private extension UIView {
    func startAnimation() {
        isAnimating = true
    }
    
    func endAnimation(withCompletion completion: (() -> Void)?) {
        isAnimating = false
        completion?()
    }
}

private extension CATransform3D {
    var scale: CGAffineTransform {
        let scaleX = sqrt(m11 * m11 + m12 * m12 + m13 * m13)
        let scaleY = sqrt(m21 * m21 + m22 * m22 + m23 * m23)
        return .init(scaleX: scaleX, y: scaleY)
    }
}

public extension TimeInterval {
    static let defaultDuration = 0.3
}
