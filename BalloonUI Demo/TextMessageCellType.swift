//
//  TextMessageCellType.swift
//  BalloonUI
//
//  Created by muukii on 7/24/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation
import Instantiatable
import BalloonUI

typealias Balloon = BalloonLabel

class TextMessageCell: UICollectionViewCell {
    
    weak var label: Balloon!
    
    func update(viewModel: TextMessageCellViewModel, updateType: UpdateType) {
        
        label?.attributedText = viewModel.attributedText
//        label.text = viewModel.text

        if updateType == .Sizing {
            contentView.invalidateIntrinsicContentSize()
        }
    }
}

extension TextMessageCell {
    enum UpdateType {
        case Normal
        case Sizing
    }
}
