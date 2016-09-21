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

open class BalloonLabel: BalloonView {
    
    open var didTapUrl: ((_ url: URL) -> Void)?
    open var enableCenteringCharactor: Bool = true
    
    open var leftOffset: CGFloat {
        switch self.type {
        case .left:
            return 5.0
        case .right:
            return 0.0
        }
    }
    
    open var rightOffset: CGFloat {
        switch self.type {
        case .left:
            return 0.0
        case .right:
            return 5.0
        }
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        var frame = bounds
        
        frame.origin.x += leftOffset
        frame.size.width -= (leftOffset + rightOffset)
        
        label.frame = frame
    }
    
    open override func configureView() {
        super.configureView()
        label.delegate = self
        label.backgroundColor = UIColor.clear
        label.dataDetectorTypes = UIDataDetectorTypes.link
        label.layer.drawsAsynchronously = true
        label.clearsContextBeforeDrawing = false
        
        addSubview(label)
        
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressGesture))
        addGestureRecognizer(gesture)
    }
    
    open var preferredMaxLayoutWidth: CGFloat = 0 {
        didSet {
            self.label.preferredMaxLayoutWidth = self.preferredMaxLayoutWidth
        }
    }
    
    open var attributedText: NSAttributedString? {
        get {
            return self.label.attributedText
        }
        set {
            label.attributedText = newValue
            invalidateIntrinsicContentSize()
        }
    }
    
    open override var intrinsicContentSize : CGSize {
        
        struct Static {
            static let cache = NSCache<NSString, NSValue>()
        }
        
        let cacheKey = "\(label.attributedText.hashValue)|\(preferredMaxLayoutWidth)"
        
        if let size = Static.cache.object(forKey: cacheKey as NSString)?.cgSizeValue {
            return size
        }
        
        let targetSize = CGSize(width: self.preferredMaxLayoutWidth, height: CGFloat.infinity)
        let size = label.attributedText.boundingRect(with: targetSize, options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil).size
        
        let scale = UIScreen.main.scale
        
        let width = ceil(size.width * scale) * (1.0 / scale)
        let height = ceil(size.height * scale) * (1.0 / scale)
        
        let roundedSize = CGSize(
            width: width + (leftOffset + rightOffset) + (label.textContainerInset.right + label.textContainerInset.left),
            height: height + (label.textContainerInset.top + label.textContainerInset.bottom)
        )
        
        Static.cache.setObject(NSValue(cgSize: roundedSize), forKey: cacheKey as NSString)
        
        return roundedSize
    }
    
    
    fileprivate let label: BalloonLabelTextView = {
        let textView = BalloonLabelTextView(frame: CGRect.zero)
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.showsHorizontalScrollIndicator = false
        textView.showsVerticalScrollIndicator = false
        textView.textContainerInset = UIEdgeInsetsMake(8, 8, 8, 8)
        textView.textContainer.lineFragmentPadding = 0
        textView.layoutManager.allowsNonContiguousLayout = true
        
        textView.linkTextAttributes = [
            NSUnderlineStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue,
            NSForegroundColorAttributeName: UIColor.blue
        ]
        return textView
    }()
    
    // MARK: UIResponder
    
    fileprivate dynamic func handleLongPressGesture(_ sender: UILongPressGestureRecognizer) {
        
        guard let view = sender.view else {
            
            return
        }
        if case .began = sender.state {
            view.becomeFirstResponder()
            let menuController = UIMenuController.shared
            menuController.setTargetRect(view.frame, in: view.superview!)
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
    
    public func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        
        didTapUrl?(URL)
        return false
    }
    
    public func textView(_ textView: UITextView, shouldInteractWith textAttachment: NSTextAttachment, in characterRange: NSRange) -> Bool {
        return false
    }
}
