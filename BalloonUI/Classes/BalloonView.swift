// BalloonLabel.swift
//
// Copyright (c) 2015 muukii
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import QuartzCore
import UIKit

public class BalloonView: UIView {
    
    public enum BalloonType {
        case Right
        case Left
        
        func path(frame: CGRect) -> CGPath {
            switch self {
            case .Left:
                return BalloonView.leftBalloonPath(frame)
            case .Right:
                return BalloonView.rigthBalloonPath(frame)
            }
        }
    }
    
    public let minimumSize = CGSize(width: 40, height: 35)
    
    public var type: BalloonType = .Right {
        didSet {
            self.layoutIfNeeded()
        }
    }
    
    public var balloonColor: UIColor? {
        get {
            return self.layer.fillColor.map { UIColor(CGColor: $0) }
        }
        set {
            self.layer.fillColor = newValue?.CGColor
        }
    }
    
    public var borderWidth: CGFloat {
        get {
            
            return self.layer.lineWidth
        }
        set {
            
            self.layer.lineWidth = borderWidth
        }
    }
    
    public var borderColor: UIColor {
        get {
            return UIColor(CGColor: self.layer.strokeColor ?? UIColor.clearColor().CGColor) ?? UIColor.clearColor()
        }
        set {
            
            self.layer.strokeColor = newValue.CGColor
        }
    }
    
    public func configureView() {
        
        self.opaque = true
        
        self.layer.drawsAsynchronously = true
//        self.layer.rasterizationScale = UIScreen.mainScreen().scale
//        self.layer.shouldRasterize = true
        
        let minWidth = NSLayoutConstraint(
            item: self,
            attribute: .Width,
            relatedBy: .GreaterThanOrEqual,
            toItem: nil,
            attribute: .Width,
            multiplier: 1.0,
            constant: minimumSize.width
        )
        
        let minHeight = NSLayoutConstraint(
            item: self,
            attribute: .Height,
            relatedBy: .GreaterThanOrEqual,
            toItem: nil,
            attribute: .Height,
            multiplier: 1.0,
            constant: minimumSize.height
        )
        
        self.addConstraints([minWidth, minHeight])
    }
    
    // MARK: UIView
    
    public override class func requiresConstraintBasedLayout() -> Bool {
        return true
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureView()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        self.configureView()
    }
    
    public override class func layerClass() -> AnyClass {
        return CAShapeLayer.self
    }
    
    public override var layer: CAShapeLayer {
        return super.layer as! CAShapeLayer
    }
    
    public override func layoutSublayersOfLayer(layer: CALayer) {
        super.layoutSublayersOfLayer(layer)
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        self.layer.path = self.type.path(self.bounds)        
        CATransaction.commit()
    }
    
    public override var frame: CGRect {
        get {
            return super.frame
        }
        set {
            var frame = newValue
            frame.size.height = max(frame.size.height, minimumSize.height)
            frame.size.width = max(frame.size.width, minimumSize.width)
            super.frame = frame
        }
    }
    
    public override var bounds: CGRect {
        get {
            return super.bounds
        }
        set {
            var bounds = newValue
            bounds.size.height = max(bounds.size.height, minimumSize.height)
            bounds.size.width = max(bounds.size.width, minimumSize.width)
            super.bounds = bounds
        }
    }
    
    // MARK: - Private    
    
    private static func leftBalloonPath(frame: CGRect) -> CGPath {
        let leftBalloonPath = UIBezierPath()
        leftBalloonPath.moveToPoint(
            CGPoint(x: frame.minX + 0.21, y: frame.minY + 4.78))
        leftBalloonPath.addCurveToPoint(
            CGPoint(x: frame.minX + 0.86, y: frame.minY + 4.75),
            controlPoint1: CGPoint(x: frame.minX + 0.58, y: frame.minY + 4.76),
            controlPoint2: CGPoint(x: frame.minX + 0.51, y: frame.minY + 4.75))
        leftBalloonPath.addCurveToPoint(
            CGPoint(x: frame.minX + 8.67, y: frame.minY + 7.58),
            controlPoint1: CGPoint(x: frame.minX + 4.08, y: frame.minY + 4.75),
            controlPoint2: CGPoint(x: frame.minX + 6.65, y: frame.minY + 5.85))
        leftBalloonPath.addCurveToPoint(
            CGPoint(x: frame.minX + 23.03, y: frame.minY),
            controlPoint1: CGPoint(x: frame.minX + 11.79, y: frame.minY + 3),
            controlPoint2: CGPoint(x: frame.minX + 17.06, y: frame.minY))
        leftBalloonPath.addLineToPoint(
            CGPoint(x: frame.maxX - 17.45, y: frame.minY))
        leftBalloonPath.addCurveToPoint(
            CGPoint(x: frame.maxX, y: frame.minY + 17.28),
            controlPoint1: CGPoint(x: frame.maxX - 7.86, y: frame.minY),
            controlPoint2: CGPoint(x: frame.maxX, y: frame.minY + 7.74))
        leftBalloonPath.addLineToPoint(
            CGPoint(x: frame.maxX, y: frame.maxY - 17.28))
        leftBalloonPath.addCurveToPoint(
            CGPoint(x: frame.maxX - 17.35, y: frame.maxY),
            controlPoint1: CGPoint(x: frame.maxX, y: frame.maxY - 7.74),
            controlPoint2: CGPoint(x: frame.maxX - 7.77, y: frame.maxY))
        leftBalloonPath.addLineToPoint(
            CGPoint(x: frame.minX + 23.03, y: frame.maxY))
        leftBalloonPath.addCurveToPoint(
            CGPoint(x: frame.minX + 5.68, y: frame.maxY - 17.28),
            controlPoint1: CGPoint(x: frame.minX + 13.45, y: frame.maxY),
            controlPoint2: CGPoint(x: frame.minX + 5.68, y: frame.maxY - 7.74))
        leftBalloonPath.addCurveToPoint(
            CGPoint(x: frame.minX + 5.7, y: frame.minY + 16.5),
            controlPoint1: CGPoint(x: frame.minX + 5.68, y: frame.maxY - 17.28),
            controlPoint2: CGPoint(x: frame.minX + 5.7, y: frame.minY + 17.18))
        leftBalloonPath.addCurveToPoint(
            CGPoint(x: frame.minX + 0.19, y: frame.minY + 5.21),
            controlPoint1: CGPoint(x: frame.minX + 5.7, y: frame.minY + 11.78),
            controlPoint2: CGPoint(x: frame.minX + 5.42, y: frame.minY + 5.91))
        leftBalloonPath.addCurveToPoint(
            CGPoint(x: frame.minX, y: frame.minY + 4.99),
            controlPoint1: CGPoint(x: frame.minX + 0.08, y: frame.minY + 5.2),
            controlPoint2: CGPoint(x: frame.minX - 0, y: frame.minY + 5.1))
        leftBalloonPath.addCurveToPoint(
            CGPoint(x: frame.minX + 0.21, y: frame.minY + 4.78),
            controlPoint1: CGPoint(x: frame.minX + 0, y: frame.minY + 4.88),
            controlPoint2: CGPoint(x: frame.minX + 0.09, y: frame.minY + 4.79))
        leftBalloonPath.closePath()
        return leftBalloonPath.CGPath
    }
    
    private static func rigthBalloonPath(frame: CGRect) -> CGPath {
        let rightBalloonPath = UIBezierPath()
        rightBalloonPath.moveToPoint(
            CGPoint(x: frame.maxX - 0.21, y: frame.minY + 4.78))
        rightBalloonPath.addCurveToPoint(
            CGPoint(x: frame.maxX - 0.86, y: frame.minY + 4.75),
            controlPoint1: CGPoint(x: frame.maxX - 0.58, y: frame.minY + 4.76),
            controlPoint2: CGPoint(x: frame.maxX - 0.51, y: frame.minY + 4.75))
        rightBalloonPath.addCurveToPoint(
            CGPoint(x: frame.maxX - 8.67, y: frame.minY + 7.58),
            controlPoint1: CGPoint(x: frame.maxX - 4.08, y: frame.minY + 4.75),
            controlPoint2: CGPoint(x: frame.maxX - 6.65, y: frame.minY + 5.85))
        rightBalloonPath.addCurveToPoint(
            CGPoint(x: frame.maxX - 23.03, y: frame.minY),
            controlPoint1: CGPoint(x: frame.maxX - 11.79, y: frame.minY + 3),
            controlPoint2: CGPoint(x: frame.maxX - 17.06, y: frame.minY))
        rightBalloonPath.addLineToPoint(
            CGPoint(x: frame.minX + 17.45, y: frame.minY))
        rightBalloonPath.addCurveToPoint(
            CGPoint(x: frame.minX, y: frame.minY + 17.28),
            controlPoint1: CGPoint(x: frame.minX + 7.86, y: frame.minY),
            controlPoint2: CGPoint(x: frame.minX, y: frame.minY + 7.74))
        rightBalloonPath.addLineToPoint(
            CGPoint(x: frame.minX, y: frame.maxY - 17.28))
        rightBalloonPath.addCurveToPoint(
            CGPoint(x: frame.minX + 17.35, y: frame.maxY),
            controlPoint1: CGPoint(x: frame.minX, y: frame.maxY - 7.74),
            controlPoint2: CGPoint(x: frame.minX + 7.77, y: frame.maxY))
        rightBalloonPath.addLineToPoint(
            CGPoint(x: frame.maxX - 23.03, y: frame.maxY))
        rightBalloonPath.addCurveToPoint(
            CGPoint(x: frame.maxX - 5.68, y: frame.maxY - 17.28),
            controlPoint1: CGPoint(x: frame.maxX - 13.45, y: frame.maxY),
            controlPoint2: CGPoint(x: frame.maxX - 5.68, y: frame.maxY - 7.74))
        rightBalloonPath.addCurveToPoint(
            CGPoint(x: frame.maxX - 5.7, y: frame.minY + 16.5),
            controlPoint1: CGPoint(x: frame.maxX - 5.68, y: frame.maxY - 17.28),
            controlPoint2: CGPoint(x: frame.maxX - 5.7, y: frame.minY + 17.18))
        rightBalloonPath.addCurveToPoint(
            CGPoint(x: frame.maxX - 0.19, y: frame.minY + 5.21),
            controlPoint1: CGPoint(x: frame.maxX - 5.7, y: frame.minY + 11.78),
            controlPoint2: CGPoint(x: frame.maxX - 5.42, y: frame.minY + 5.91))
        rightBalloonPath.addCurveToPoint(
            CGPoint(x: frame.maxX, y: frame.minY + 4.99),
            controlPoint1: CGPoint(x: frame.maxX - 0.08, y: frame.minY + 5.2),
            controlPoint2: CGPoint(x: frame.maxX + 0, y: frame.minY + 5.1))
        rightBalloonPath.addCurveToPoint(
            CGPoint(x: frame.maxX - 0.21, y: frame.minY + 4.78),
            controlPoint1: CGPoint(x: frame.maxX - 0, y: frame.minY + 4.88),
            controlPoint2: CGPoint(x: frame.maxX - 0.09, y: frame.minY + 4.79))
        rightBalloonPath.closePath()
        return rightBalloonPath.CGPath
    }
}
