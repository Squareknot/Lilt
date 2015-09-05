//
//  AnimationData.swift
//  Lilt
//
//  Created by Jordan Kay on 9/5/15.
//  Copyright © 2015 jordanekay. All rights reserved.
//

let animationData: [Curve: [Easing: Info]] = [
    .Sine: [
        .In: .Name(kCAMediaTimingFunctionEaseIn),
        .Out: .Name(kCAMediaTimingFunctionEaseOut),
        .InOut: .Name(kCAMediaTimingFunctionEaseInEaseOut)
    ],
    .Exponential: [
        .In: .Points((0.95, 0.05, 0.795, 0.035)),
        .Out: .Points((0.19, 1.0, 0.22, 1.0)),
        .InOut: .Points((1.0, 0.0, 0.0, 1.0))
    ]
]
