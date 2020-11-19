//
//  AnimationQueue.swift
//  Squareknot
//
//  Created by Jordan Kay on 7/28/16.
//  Copyright © 2016 Squareknot. All rights reserved.
//

import UIKit

public class AnimationQueue {
    public var beginAction: (() -> Void)?
    public var endAction: (() -> Void)?
    
    fileprivate var queue = DispatchQueue(label: "animationQueue")
    fileprivate var semaphore: DispatchSemaphore!
    fileprivate var blocks: [DispatchWorkItem] = [] {
        didSet {
            if blocks.count == 1 && oldValue.count == 0 {
                beginAction?()
            } else if blocks.count == 0 {
                endAction?()
            }
        }
    }
    
    public init() {}
    
    public var isAnimating: Bool {
        return blocks.count > 0
    }
    
    public func cancelAnimations() {
        blocks.forEach { $0.cancel() }
        blocks = []
    }
    
    public func animate(withDuration duration: TimeInterval, delay: TimeInterval = 0, options: UIView.AnimationOptions = [], animations: @escaping () -> Void) {
        animate(withDuration: duration, delay: delay, options: options, animations: animations, completion: nil)
    }
    
    public func animate(withDuration duration: TimeInterval, delay: TimeInterval = 0, options: UIView.AnimationOptions = [], animations: @escaping () -> Void, completion: ((Bool) -> Void)?) {
        performAnimationsSerially { [weak self] in
            if let strongSelf = self {
                UIView.animate(withDuration: duration, delay: delay, options: options, animations: animations) { finished in
                    strongSelf.runCompletionBlock(completion, animationDidFinish: finished)
                }
            }
        }
    }
    
    public func transition(with view: UIView, duration: TimeInterval, options: UIView.AnimationOptions = [], animations: @escaping () -> Void) {
        transition(with: view, duration: duration, options: options, animations: animations, completion: nil)
    }
    
    public func transition(with view: UIView, duration: TimeInterval, options: UIView.AnimationOptions = [], animations: @escaping () -> Void, completion: ((Bool) -> Void)?) {
        performAnimationsSerially { [weak self, weak view] in
            if let strongSelf = self, let view = view {
                UIView.transition(with: view, duration: duration, options: options, animations: animations) { finished in
                    strongSelf.runCompletionBlock(completion, animationDidFinish: finished)
                }
            }
        }
    }
}

private extension AnimationQueue {
    func performAnimationsSerially(_ animations: @escaping () -> Void) {
        let item = DispatchWorkItem(block: animations)
        blocks.append(item)
        
        queue.async { [weak self] in
            guard let `self` = self else { return }
            self.semaphore = DispatchSemaphore(value: 0)
            
            DispatchQueue.main.async(execute: item)
            let _ = self.semaphore.wait(timeout: .distantFuture)
        }
    }
    
    func runCompletionBlock(_ completionBlock: ((Bool) -> Void)?, animationDidFinish finished: Bool) {
        completionBlock?(finished)
        if blocks.count > 0 {
            blocks.remove(at: 0)
        }
        semaphore.signal()
    }
}
