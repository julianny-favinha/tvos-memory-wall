//
//  ConfettiView.swift
//  photo-wall
//
//  Created by Giovani Nascimento Pereira on 20/05/18.
//  Copyright © 2018 Giovani Nascimento Pereira. All rights reserved.
//
// Reference: https://github.com/sudeepag/SAConfettiView/blob/master/Pod/Classes/SAConfettiView.swift

import UIKit
import QuartzCore

public class ConfettiView: UIView {
    
    public enum ConfettiType {
        case star
        case confetti
    }
    
    var emitter: CAEmitterLayer!
    public var colors: [UIColor]!
    public var intensity: Float!
    public var type: ConfettiType!
    private var active: Bool!
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    public init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        setup()
    }
    
    override public func didMoveToSuperview() {
        super.didMoveToSuperview()
        startConfetti()
    }
    
    func setup() {
        colors = [
            UIColor(red: 0.95, green: 0.40, blue: 0.27, alpha: 1.0),
            UIColor(red: 1.00, green: 0.78, blue: 0.36, alpha: 1.0),
            UIColor(red: 0.48, green: 0.78, blue: 0.64, alpha: 1.0),
            UIColor(red: 0.30, green: 0.76, blue: 0.85, alpha: 1.0),
            UIColor(red: 0.58, green: 0.39, blue: 0.55, alpha: 1.0)
        ]
        intensity = 0.5
        type = .confetti
        active = true
    }
    
    public func startConfetti() {
        emitter = CAEmitterLayer()
        
        emitter.emitterPosition = CGPoint(x: frame.size.width / 2.0, y: 0)
        emitter.emitterShape = kCAEmitterLayerLine
        emitter.emitterSize = CGSize(width: frame.size.width, height: 1)
        
        var cells = [CAEmitterCell]()
        for color in colors {
            cells.append(confettiWithColor(color: color))
        }
        
        emitter.emitterCells = cells
        layer.addSublayer(emitter)
        active = true
    }
    
    public func stopConfetti() {
        emitter?.birthRate = 0
        active = false
    }
    
    func imageForType(type: ConfettiType) -> UIImage? {
        switch type {
        case .confetti:
            return #imageLiteral(resourceName: "confetti")
        case .star:
            return #imageLiteral(resourceName: "star")
        }
    }
    
    func confettiWithColor(color: UIColor) -> CAEmitterCell {
        let confetti = CAEmitterCell()
        confetti.birthRate = 6.0 * intensity
        confetti.lifetime = 14.0 * intensity
        confetti.lifetimeRange = 0
        confetti.color = color.cgColor
        confetti.velocity = CGFloat(350.0 * intensity)
        confetti.velocityRange = CGFloat(80.0 * intensity)
        confetti.emissionLongitude = CGFloat(Double.pi)
        confetti.emissionRange = CGFloat(Double.pi)
        confetti.spin = CGFloat(3.5 * intensity)
        confetti.spinRange = CGFloat(4.0 * intensity)
        confetti.scaleRange = CGFloat(intensity)
        confetti.scaleSpeed = CGFloat(-0.1 * intensity)
        confetti.contents = imageForType(type: type)!.cgImage
        return confetti
    }
    
    public func isActive() -> Bool {
        return self.active
    }
}
