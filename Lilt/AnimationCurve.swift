//
//  AnimationCurve.swift
//  Lilt
//
//  Created by Jordan Kay on 9/5/15.
//  Copyright © 2015 jordanekay. All rights reserved.
//

typealias ControlPoints = (Float, Float, Float, Float)

public enum Curve: Int {
    case Sine
    case Spring
    case Linear
    case Exponential
}

public enum Easing: Int {
    case In
    case Out
    case InOut
}

enum Info {
    case Name(String)
    case Points(ControlPoints)
}

public struct AnimationCurve {
    private let curveType: Curve
    private let easing: Easing
    
    var timingFunction: CAMediaTimingFunction {
        if curveType == .Linear {
            return CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        }
        
        switch animationData[curveType]![easing]! {
        case let .Name(name):
            return CAMediaTimingFunction(name: name)
        case let .Points(c1x, c1y, c2x, c2y):
            return CAMediaTimingFunction(controlPoints: c1x, c1y, c2x, c2y)
        }
    }
    
    public init(_ curve: Curve = .Sine, ease easing: Easing = .InOut) {
        self.curveType = curve
        self.easing = easing
    }
}
