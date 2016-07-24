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

import UIKit
import Cartography

public class BalloonLabel: BalloonView {
    
    public var didTapUrl: ((url: NSURL) -> Void)?
    public var enableCenteringCharactor: Bool = true
    
    public let label: BalloonLabelTextView = {
        let textView = BalloonLabelTextView(frame: CGRect.zero)
        textView.scrollEnabled = false
        textView.editable = false
        textView.showsHorizontalScrollIndicator = false
        textView.showsVerticalScrollIndicator = false
        textView.layer.rasterizationScale = UIScreen.mainScreen().scale
        textView.layer.shouldRasterize = true
        textView.linkTextAttributes = [
            NSUnderlineStyleAttributeName: NSUnderlineStyle.StyleSingle.rawValue,
            NSForegroundColorAttributeName: UIColor.blueColor()
        ]
        textView.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)        
        return textView
    }()
    
    public struct Margin {
        var left: NSLayoutConstraint
        var top: NSLayoutConstraint
        var right: NSLayoutConstraint
        var bottom: NSLayoutConstraint
        init(left: NSLayoutConstraint, top: NSLayoutConstraint, right: NSLayoutConstraint, bottom: NSLayoutConstraint) {
            self.left = left
            self.top = top
            self.right = right
            self.bottom = bottom
        }
    }
    
    public var leftOffset: CGFloat {
        switch self.type {
        case .Left:
            return 5.0
        case .Right:
            return 0.0
        }
    }
    
    public var rightOffset: CGFloat {
        switch self.type {
        case .Left:
            return 0.0
        case .Right:
            return 5.0
        }
    }
    
    public func labelMargin() -> UIEdgeInsets {
        return UIEdgeInsets(top: 9, left: 10, bottom: 8, right: 10)
    }
    
    public var labelMarginContraints: Margin!
    
    public override func configureView() {
        super.configureView()
        self.label.delegate = self
        self.label.backgroundColor = UIColor.clearColor()
        self.label.translatesAutoresizingMaskIntoConstraints = false
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.label.dataDetectorTypes = UIDataDetectorTypes.Link
        
        self.addSubview(self.label)
        
        constrain(self.label) {
            
            let superview = $0.superview!
            
            let margin = Margin(
                left: $0.left == superview.left,
                top: $0.top == superview.top,
                right: superview.right == $0.right,
                bottom: superview.bottom == $0.bottom
            )
            
            self.labelMarginContraints = margin
        }
        
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressGesture))
        self.addGestureRecognizer(gesture)
    }
    
    public override func updateConstraints() {
        
        self.labelMarginContraints.left.constant = self.labelMargin().left + self.leftOffset
        self.labelMarginContraints.top.constant = self.labelMargin().top
        self.labelMarginContraints.right.constant = self.labelMargin().right + self.rightOffset
        self.labelMarginContraints.bottom.constant = self.labelMargin().bottom
        super.updateConstraints()
    }
    
    public var preferredMaxLayoutWidth: CGFloat = 0 {
        didSet {
            self.label.preferredMaxLayoutWidth = self.preferredMaxLayoutWidth - (self.labelMargin().left + self.labelMargin().right + self.leftOffset + self.rightOffset)
        }
    }
    
    public var attributedText: NSAttributedString? {
        get {
            return self.label.attributedText
        }
        set {
            
            self.label.attributedText = newValue
            
            guard let text = newValue else {
                return
            }
            
            if self.enableCenteringCharactor == true && text.string.characters.count == 1 {
                if self.label.textAlignment != .Center {
                    self.label.textAlignment = .Center
                }
            } else {
                if self.label.textAlignment != .Left {
                    self.label.textAlignment = .Left
                }
            }
            
            self.invalidateIntrinsicContentSize()
        }
    }
        
    // MARK: UIResponder
    
    private dynamic func handleLongPressGesture(sender: UILongPressGestureRecognizer) {
        
        guard let view = sender.view else {
            
            return
        }
        if case .Began = sender.state {
            view.becomeFirstResponder()
            let menuController = UIMenuController.sharedMenuController()
            menuController.setTargetRect(view.frame, inView: view.superview!)
            menuController.setMenuVisible(true, animated: true)
            
            // TODO: 
//            view.registerForNotificationsWithName(
//                UIMenuControllerWillHideMenuNotification,
//                fromObject: menuController,
//                targetBlock: { [weak view] (_) -> Void in
//                    
//                    view?.resignFirstResponder()
//                }
//            )
        }
    }
}

extension BalloonLabel: UITextViewDelegate {
    
    public func textView(textView: UITextView, shouldInteractWithURL URL: NSURL, inRange characterRange: NSRange) -> Bool {
        
        let urlString: NSString = URL.scheme
        if urlString.rangeOfString("http").location != NSNotFound ||
            urlString.rangeOfString("Http").location != NSNotFound ||
            urlString.rangeOfString("https").location != NSNotFound ||
            urlString.rangeOfString("Https").location != NSNotFound
        {
            self.didTapUrl?(url: URL)
        }
        return false
    }
    
    public func textView(textView: UITextView, shouldInteractWithTextAttachment textAttachment: NSTextAttachment, inRange characterRange: NSRange) -> Bool {
        return false
    }
    
}
