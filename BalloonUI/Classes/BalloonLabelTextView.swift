// BalloonLabelTextView.swift
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

import Foundation
import UIKit

public final class BalloonLabelTextView: UITextView {
    
    public var preferredMaxLayoutWidth: CGFloat = 100
        
    public override func intrinsicContentSize() -> CGSize {
        

        
        let size = self.sizeThatFits(CGSize(width: self.preferredMaxLayoutWidth, height: CGFloat.infinity))
        return size
    }
    
    public override func canBecomeFirstResponder() -> Bool {
        return false
    }
    
    public override func nextResponder() -> UIResponder? {
        return self.superview
    }
    
    public override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
        
        /// - [ios7 - リンクが押せるテキストをTableViewCellに配置する - Qiita](http://qiita.com/fmtonakai/items/669fe461fd9673dc8e50)
        
        var p = point
        p.y -= self.textContainerInset.top
        p.x -= self.textContainerInset.left
        
        let i = self.layoutManager.characterIndexForPoint(p, inTextContainer: self.textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        
        var range = NSRange(location: 0, length: 0)
        let attr = self.textStorage.attributesAtIndex(i, effectiveRange: &range)
        
        if attr[NSLinkAttributeName] != nil {
            var touchingLink = false
            let glyphIndex = self.layoutManager.glyphIndexForCharacterAtIndex(i)
            self.layoutManager.enumerateLineFragmentsForGlyphRange(NSRange(location: glyphIndex, length: 1), usingBlock: { (rect, usedRect, container, glyphRange, stop) -> Void in
                
                if CGRectContainsPoint(usedRect, p) {
                    touchingLink = true
                    stop.memory = true
                }
            })
            return (touchingLink) ? self : nil
        }
        return nil
    }
    
    public override func selectionRectsForRange(range: UITextRange) -> [AnyObject] {
        return []
    }
}
