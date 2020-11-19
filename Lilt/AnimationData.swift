//
//  AnimationData.swift
//  Lilt
//
//  Created by Jordan Kay on 9/5/15.
//  Copyright © 2015 Squareknot. All rights reserved.
//

let animationData: [Curve: [Easing: Info]] = [
    .sine: [
        .in: .name(CAMediaTimingFunctionName.easeIn.rawValue),
        .out: .name(CAMediaTimingFunctionName.easeOut.rawValue),
        .inOut: .name(CAMediaTimingFunctionName.easeInEaseOut.rawValue)
    ],
    .quad: [
        .in: .points((0.55, 0.085, 0.68, 0.53)),
        .out: .points((0.25, 0.46, 0.45, 0.94)),
        .inOut: .points((0.455, 0.03, 0.515, 0.955))
    ],
    .cubic: [
        .in: .points((0.55, 0.055, 0.675, 0.19)),
        .out: .points((0.215, 0.61, 0.355, 1)),
        .inOut: .points((0.645, 0.045, 0.355, 1))
    ],
    .quart: [
        .in: .points((0.895, 0.03, 0.685, 0.22)),
        .out: .points((0.165, 0.84, 0.44, 1)),
        .inOut: .points((0.77, 0, 0.175, 1))
    ],
    .quint: [
        .in: .points((0.755, 0.05, 0.855, 0.06)),
        .out: .points((0.23, 1, 0.32, 1)),
        .inOut: .points((0.86, 0, 0.07, 1))
    ],
    .exponential: [
        .in: .points((0.95, 0.05, 0.795, 0.035)),
        .out: .points((0.19, 1.0, 0.22, 1.0)),
        .inOut: .points((1.0, 0.0, 0.0, 1.0))
    ]
]

let organicSpringDamping: CGFloat = 500

extension UIViewController {
    public static var animationDuration: TimeInterval {
        return 0.5
    }
}
