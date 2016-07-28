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
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        var frame = bounds
        
        frame.origin.x += leftOffset
        frame.size.width -= (leftOffset + rightOffset)
        
        label.frame = frame
    }
    
    public override func configureView() {
        super.configureView()
        label.delegate = self
        label.backgroundColor = UIColor.clearColor()
        label.dataDetectorTypes = UIDataDetectorTypes.Link
        label.layer.drawsAsynchronously = true
        label.clearsContextBeforeDrawing = false
        
        addSubview(label)
        
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressGesture))
        addGestureRecognizer(gesture)
    }
    
    public var preferredMaxLayoutWidth: CGFloat = 0 {
        didSet {
            self.label.preferredMaxLayoutWidth = self.preferredMaxLayoutWidth
        }
    }
    
    public var attributedText: NSAttributedString? {
        get {
            return self.label.attributedText
        }
        set {
            label.attributedText = newValue
            invalidateIntrinsicContentSize()
        }
    }
    
    public override func intrinsicContentSize() -> CGSize {
        
        struct Static {
            static let cache = NSCache()
        }
        
        let cacheKey = "\(label.attributedText.hashValue)|\(preferredMaxLayoutWidth)"
        
        if let size = (Static.cache.objectForKey(cacheKey) as? NSValue)?.CGSizeValue() {
            return size
        }
        
        let targetSize = CGSize(width: self.preferredMaxLayoutWidth, height: CGFloat.infinity)
        let size = label.attributedText.boundingRectWithSize(targetSize, options: [.UsesLineFragmentOrigin, .UsesFontLeading], context: nil).size
        
        let scale = UIScreen.mainScreen().scale
        
        let width = ceil(size.width * scale) * (1.0 / scale)
        let height = ceil(size.height * scale) * (1.0 / scale)
        
        let roundedSize = CGSize(
            width: width + (leftOffset + rightOffset) + (label.textContainerInset.right + label.textContainerInset.left),
            height: height + (label.textContainerInset.top + label.textContainerInset.bottom)
        )
        
        Static.cache.setObject(NSValue(CGSize: roundedSize), forKey: cacheKey)
        
        return roundedSize
    }
    
    
    private let label: BalloonLabelTextView = {
        let textView = BalloonLabelTextView(frame: CGRect.zero)
        textView.scrollEnabled = false
        textView.editable = false
        textView.showsHorizontalScrollIndicator = false
        textView.showsVerticalScrollIndicator = false
        textView.textContainerInset = UIEdgeInsetsMake(8, 8, 8, 8)
        textView.textContainer.lineFragmentPadding = 0
        textView.layoutManager.allowsNonContiguousLayout = true
        
        textView.linkTextAttributes = [
            NSUnderlineStyleAttributeName: NSUnderlineStyle.StyleSingle.rawValue,
            NSForegroundColorAttributeName: UIColor.blueColor()
        ]
        return textView
    }()
    
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
        
        didTapUrl?(url: URL)
        return false
    }
    
    public func textView(textView: UITextView, shouldInteractWithTextAttachment textAttachment: NSTextAttachment, inRange characterRange: NSRange) -> Bool {
        return false
    }
}
