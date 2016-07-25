//
//  TextMessageCellType.swift
//  BalloonUI
//
//  Created by muukii on 7/24/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation
import Reusable
import BalloonUI

class TextMessageCell: UICollectionViewCell, Reusable {
    
    weak var label: BalloonLabel!
    
    func update(viewModel viewModel: TextMessageCellViewModel, updateType: UpdateType) {
        
        label?.attributedText = viewModel.attributedText
//        label.text = viewModel.text
        contentView.invalidateIntrinsicContentSize()
    }
}

extension TextMessageCell {
    enum UpdateType {
        case Normal
        case Sizing
    }
}
