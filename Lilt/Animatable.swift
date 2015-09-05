//
//  Animatable.swift
//  Lilt
//
//  Created by Jordan Kay on 9/6/15.
//  Copyright © 2015 jordanekay. All rights reserved.
//

public protocol Animatable {
    func +(lhs: Self, rhs: Self) -> Self
    func -(lhs: Self, rhs: Self) -> Self
    func *(lhs: Double, rhs: Self) -> Self
}

extension CGFloat: Animatable {}
extension CGPoint: Animatable {}
extension CGRect: Animatable {}

public func *(lhs: Double, rhs: CGFloat) -> CGFloat {
    return CGFloat(lhs) * rhs
}

public func +(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
    return CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
}

public func -(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
    return CGPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
}

public func *(lhs: Double, rhs: CGPoint) -> CGPoint {
    return CGPoint(x: lhs * rhs.x, y: lhs * rhs.y)
}

public func +(lhs: CGRect, rhs: CGRect) -> CGRect {
    return CGRect(x: lhs.origin.x + rhs.origin.x, y: lhs.origin.y + rhs.origin.y, width: lhs.size.width + rhs.size.width, height: lhs.size.height + rhs.size.height)
}

public func -(lhs: CGRect, rhs: CGRect) -> CGRect {
    return CGRect(x: lhs.origin.x - rhs.origin.x, y: lhs.origin.y - rhs.origin.y, width: lhs.size.width - rhs.size.width, height: lhs.size.height - rhs.size.height)
}

public func *(lhs: Double, rhs: CGRect) -> CGRect {
    return CGRect(x: lhs * rhs.origin.x, y: lhs * rhs.origin.y, width: lhs * rhs.size.width, height: lhs * rhs.size.height)
}
