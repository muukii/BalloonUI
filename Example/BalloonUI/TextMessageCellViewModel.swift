//
//  TextMessageCell.ViewModel.swift
//  BalloonUI
//
//  Created by muukii on 7/24/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation
import TextAttributes
import TextAttributesUtil

final class TextMessageCellViewModel {
    
    let message: Message
    
    let attributedText: NSAttributedString
    let text: String
    let cacheKey: String
    
    init(message: Message) {
        self.message = message
        
        self.text = message.text
        self.attributedText = message.text.attributed {
            TextAttributes()
                .foregroundColor(UIColor.lightGrayColor())
        }
        
        self.cacheKey = String(message.text.hash)
    }
}
