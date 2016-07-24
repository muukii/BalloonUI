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
    let cacheKey: String
    
    init(message: Message) {
        self.message = message
        
        self.attributedText = message.text.attributed {
            TextAttributes()
                .foregroundColor(UIColor.whiteColor())
        }
        
        self.cacheKey = String(message.text.hash)
    }
}
