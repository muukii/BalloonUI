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

open class BalloonView: UIView {
    
    public enum BalloonType {
        case right
        case left
        
        func path(_ frame: CGRect) -> CGPath {
            switch self {
            case .left:
                return BalloonView.leftBalloonPath(frame)
            case .right:
                return BalloonView.rigthBalloonPath(frame)
            }
        }
    }
    
    open let minimumSize = CGSize(width: 40, height: 35)
    
    open var type: BalloonType = .right {
        didSet {
            self.layoutIfNeeded()
        }
    }
    
    open var balloonColor: UIColor? {
        get {
            return self.layer.fillColor.map { UIColor(cgColor: $0) }
        }
        set {
            self.layer.fillColor = newValue?.cgColor
        }
    }
    
    open var borderWidth: CGFloat {
        get {
            
            return self.layer.lineWidth
        }
        set {
            
            self.layer.lineWidth = borderWidth
        }
    }
    
    open var borderColor: UIColor {
        get {
            return UIColor(cgColor: self.layer.strokeColor ?? UIColor.clear.cgColor) ?? UIColor.clear
        }
        set {
            
            self.layer.strokeColor = newValue.cgColor
        }
    }
    
    open func configureView() {
        
        self.isOpaque = true
        
        self.layer.drawsAsynchronously = true
//        self.layer.rasterizationScale = UIScreen.mainScreen().scale
//        self.layer.shouldRasterize = true
        
        let minWidth = NSLayoutConstraint(
            item: self,
            attribute: .width,
            relatedBy: .greaterThanOrEqual,
            toItem: nil,
            attribute: .width,
            multiplier: 1.0,
            constant: minimumSize.width
        )
        
        let minHeight = NSLayoutConstraint(
            item: self,
            attribute: .height,
            relatedBy: .greaterThanOrEqual,
            toItem: nil,
            attribute: .height,
            multiplier: 1.0,
            constant: minimumSize.height
        )
        
        self.addConstraints([minWidth, minHeight])
    }
    
    // MARK: UIView
    
    open override class var requiresConstraintBasedLayout : Bool {
        return true
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureView()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        self.configureView()
    }
    
    open override class var layerClass : AnyClass {
        return CAShapeLayer.self
    }
    
    open override var layer: CAShapeLayer {
        return super.layer as! CAShapeLayer
    }
    
    open override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        self.layer.path = self.type.path(self.bounds)        
        CATransaction.commit()
    }
    
    open override var frame: CGRect {
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
    
    open override var bounds: CGRect {
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
    
    fileprivate static func leftBalloonPath(_ frame: CGRect) -> CGPath {
        let leftBalloonPath = UIBezierPath()
        leftBalloonPath.move(
            to: CGPoint(x: frame.minX + 0.21, y: frame.minY + 4.78))
        leftBalloonPath.addCurve(
            to: CGPoint(x: frame.minX + 0.86, y: frame.minY + 4.75),
            controlPoint1: CGPoint(x: frame.minX + 0.58, y: frame.minY + 4.76),
            controlPoint2: CGPoint(x: frame.minX + 0.51, y: frame.minY + 4.75))
        leftBalloonPath.addCurve(
            to: CGPoint(x: frame.minX + 8.67, y: frame.minY + 7.58),
            controlPoint1: CGPoint(x: frame.minX + 4.08, y: frame.minY + 4.75),
            controlPoint2: CGPoint(x: frame.minX + 6.65, y: frame.minY + 5.85))
        leftBalloonPath.addCurve(
            to: CGPoint(x: frame.minX + 23.03, y: frame.minY),
            controlPoint1: CGPoint(x: frame.minX + 11.79, y: frame.minY + 3),
            controlPoint2: CGPoint(x: frame.minX + 17.06, y: frame.minY))
        leftBalloonPath.addLine(
            to: CGPoint(x: frame.maxX - 17.45, y: frame.minY))
        leftBalloonPath.addCurve(
            to: CGPoint(x: frame.maxX, y: frame.minY + 17.28),
            controlPoint1: CGPoint(x: frame.maxX - 7.86, y: frame.minY),
            controlPoint2: CGPoint(x: frame.maxX, y: frame.minY + 7.74))
        leftBalloonPath.addLine(
            to: CGPoint(x: frame.maxX, y: frame.maxY - 17.28))
        leftBalloonPath.addCurve(
            to: CGPoint(x: frame.maxX - 17.35, y: frame.maxY),
            controlPoint1: CGPoint(x: frame.maxX, y: frame.maxY - 7.74),
            controlPoint2: CGPoint(x: frame.maxX - 7.77, y: frame.maxY))
        leftBalloonPath.addLine(
            to: CGPoint(x: frame.minX + 23.03, y: frame.maxY))
        leftBalloonPath.addCurve(
            to: CGPoint(x: frame.minX + 5.68, y: frame.maxY - 17.28),
            controlPoint1: CGPoint(x: frame.minX + 13.45, y: frame.maxY),
            controlPoint2: CGPoint(x: frame.minX + 5.68, y: frame.maxY - 7.74))
        leftBalloonPath.addCurve(
            to: CGPoint(x: frame.minX + 5.7, y: frame.minY + 16.5),
            controlPoint1: CGPoint(x: frame.minX + 5.68, y: frame.maxY - 17.28),
            controlPoint2: CGPoint(x: frame.minX + 5.7, y: frame.minY + 17.18))
        leftBalloonPath.addCurve(
            to: CGPoint(x: frame.minX + 0.19, y: frame.minY + 5.21),
            controlPoint1: CGPoint(x: frame.minX + 5.7, y: frame.minY + 11.78),
            controlPoint2: CGPoint(x: frame.minX + 5.42, y: frame.minY + 5.91))
        leftBalloonPath.addCurve(
            to: CGPoint(x: frame.minX, y: frame.minY + 4.99),
            controlPoint1: CGPoint(x: frame.minX + 0.08, y: frame.minY + 5.2),
            controlPoint2: CGPoint(x: frame.minX - 0, y: frame.minY + 5.1))
        leftBalloonPath.addCurve(
            to: CGPoint(x: frame.minX + 0.21, y: frame.minY + 4.78),
            controlPoint1: CGPoint(x: frame.minX + 0, y: frame.minY + 4.88),
            controlPoint2: CGPoint(x: frame.minX + 0.09, y: frame.minY + 4.79))
        leftBalloonPath.close()
        return leftBalloonPath.cgPath
    }
    
    fileprivate static func rigthBalloonPath(_ frame: CGRect) -> CGPath {
        let rightBalloonPath = UIBezierPath()
        rightBalloonPath.move(
            to: CGPoint(x: frame.maxX - 0.21, y: frame.minY + 4.78))
        rightBalloonPath.addCurve(
            to: CGPoint(x: frame.maxX - 0.86, y: frame.minY + 4.75),
            controlPoint1: CGPoint(x: frame.maxX - 0.58, y: frame.minY + 4.76),
            controlPoint2: CGPoint(x: frame.maxX - 0.51, y: frame.minY + 4.75))
        rightBalloonPath.addCurve(
            to: CGPoint(x: frame.maxX - 8.67, y: frame.minY + 7.58),
            controlPoint1: CGPoint(x: frame.maxX - 4.08, y: frame.minY + 4.75),
            controlPoint2: CGPoint(x: frame.maxX - 6.65, y: frame.minY + 5.85))
        rightBalloonPath.addCurve(
            to: CGPoint(x: frame.maxX - 23.03, y: frame.minY),
            controlPoint1: CGPoint(x: frame.maxX - 11.79, y: frame.minY + 3),
            controlPoint2: CGPoint(x: frame.maxX - 17.06, y: frame.minY))
        rightBalloonPath.addLine(
            to: CGPoint(x: frame.minX + 17.45, y: frame.minY))
        rightBalloonPath.addCurve(
            to: CGPoint(x: frame.minX, y: frame.minY + 17.28),
            controlPoint1: CGPoint(x: frame.minX + 7.86, y: frame.minY),
            controlPoint2: CGPoint(x: frame.minX, y: frame.minY + 7.74))
        rightBalloonPath.addLine(
            to: CGPoint(x: frame.minX, y: frame.maxY - 17.28))
        rightBalloonPath.addCurve(
            to: CGPoint(x: frame.minX + 17.35, y: frame.maxY),
            controlPoint1: CGPoint(x: frame.minX, y: frame.maxY - 7.74),
            controlPoint2: CGPoint(x: frame.minX + 7.77, y: frame.maxY))
        rightBalloonPath.addLine(
            to: CGPoint(x: frame.maxX - 23.03, y: frame.maxY))
        rightBalloonPath.addCurve(
            to: CGPoint(x: frame.maxX - 5.68, y: frame.maxY - 17.28),
            controlPoint1: CGPoint(x: frame.maxX - 13.45, y: frame.maxY),
            controlPoint2: CGPoint(x: frame.maxX - 5.68, y: frame.maxY - 7.74))
        rightBalloonPath.addCurve(
            to: CGPoint(x: frame.maxX - 5.7, y: frame.minY + 16.5),
            controlPoint1: CGPoint(x: frame.maxX - 5.68, y: frame.maxY - 17.28),
            controlPoint2: CGPoint(x: frame.maxX - 5.7, y: frame.minY + 17.18))
        rightBalloonPath.addCurve(
            to: CGPoint(x: frame.maxX - 0.19, y: frame.minY + 5.21),
            controlPoint1: CGPoint(x: frame.maxX - 5.7, y: frame.minY + 11.78),
            controlPoint2: CGPoint(x: frame.maxX - 5.42, y: frame.minY + 5.91))
        rightBalloonPath.addCurve(
            to: CGPoint(x: frame.maxX, y: frame.minY + 4.99),
            controlPoint1: CGPoint(x: frame.maxX - 0.08, y: frame.minY + 5.2),
            controlPoint2: CGPoint(x: frame.maxX + 0, y: frame.minY + 5.1))
        rightBalloonPath.addCurve(
            to: CGPoint(x: frame.maxX - 0.21, y: frame.minY + 4.78),
            controlPoint1: CGPoint(x: frame.maxX - 0, y: frame.minY + 4.88),
            controlPoint2: CGPoint(x: frame.maxX - 0.09, y: frame.minY + 4.79))
        rightBalloonPath.close()
        return rightBalloonPath.cgPath
    }
}
