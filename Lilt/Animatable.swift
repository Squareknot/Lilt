//
//  Animatable.swift
//  Lilt
//
//  Created by Jordan Kay on 9/6/15.
//  Copyright © 2015 Squareknot. All rights reserved.
//

public protocol Animatable {
    static func +(lhs: Self, rhs: Self) -> Self
    static func -(lhs: Self, rhs: Self) -> Self
    static func *(lhs: Double, rhs: Self) -> Self
}

extension CGFloat: Animatable {
    public static func *(lhs: Double, rhs: CGFloat) -> CGFloat {
        return CGFloat(lhs) * rhs
    }
}

extension CGPoint: Animatable {
    public static func +(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        return CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
    
    public static func -(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        return CGPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }
    
    public static func *(lhs: Double, rhs: CGPoint) -> CGPoint {
        return CGPoint(x: lhs * rhs.x, y: lhs * rhs.y)
    }
}

extension CGRect: Animatable {
    static public func +(lhs: CGRect, rhs: CGRect) -> CGRect {
        return CGRect(x: lhs.origin.x + rhs.origin.x, y: lhs.origin.y + rhs.origin.y, width: lhs.size.width + rhs.size.width, height: lhs.size.height + rhs.size.height)
    }
    
    static public func -(lhs: CGRect, rhs: CGRect) -> CGRect {
        return CGRect(x: lhs.origin.x - rhs.origin.x, y: lhs.origin.y - rhs.origin.y, width: lhs.size.width - rhs.size.width, height: lhs.size.height - rhs.size.height)
    }
    
    static public func *(lhs: Double, rhs: CGRect) -> CGRect {
        return CGRect(x: lhs * rhs.origin.x, y: lhs * rhs.origin.y, width: lhs * rhs.size.width, height: lhs * rhs.size.height)
    }
}
