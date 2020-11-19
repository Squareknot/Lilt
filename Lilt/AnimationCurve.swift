//
//  Lilt.AnimationCurve.swift
//  Lilt
//
//  Created by Jordan Kay on 9/5/15.
//  Copyright © 2015 Squareknot. All rights reserved.
//

typealias ControlPoints = (Float, Float, Float, Float)

public enum Curve: Int {
    case sine
    case quad
    case cubic
    case quart
    case quint
    case spring
    case linear
    case exponential
}

public enum Easing: Int {
    case `in`
    case out
    case inOut
}

enum Info {
    case name(String)
    case points(ControlPoints)
}

protocol TimingFunction {
    func value(_ t: Double) -> Double
}

public struct AnimationCurve {
    let curveType: Curve
    private let easing: Easing
    
    var timingFunction: TimingFunction {
        switch curveType {
        case .linear:
            return CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        case .spring:
            return SpringTimingFunction()
        default:
            switch animationData[curveType]![easing]! {
            case let .name(name):
                return CAMediaTimingFunction(name: CAMediaTimingFunctionName(rawValue: name))
            case let .points(c1x, c1y, c2x, c2y):
                return CAMediaTimingFunction(controlPoints: c1x, c1y, c2x, c2y)
            }
        }
    }
    
    public init(_ curve: Curve = .sine, ease easing: Easing = .inOut) {
        self.curveType = curve
        self.easing = easing
    }
}

extension CAMediaTimingFunction: TimingFunction {
    private func point(_ i: Int) -> Double {
        let values = UnsafeMutablePointer<Float>.allocate(capacity: 2)
        self.getControlPoint(at: i, values: values)
        let p = Double(values[1])
        values.deallocate()
        return p
    }
    
    func value(_ t: Double) -> Double {
        let a = pow(1 - t, 3) * point(0)
        let b = 3 * pow(1 - t, 2) * t * point(1)
        let c = 3 * (1 - t) * pow(t, 2) * point(2)
        let d = pow(t, 3) * point(3)
        return a + b + c + d
    }
}

private struct SpringTimingFunction: TimingFunction {
    func value(_ t: Double) -> Double {
        return t // TODO
    }
}
