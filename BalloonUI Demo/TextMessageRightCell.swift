//
//  TextMessageRightCell.swift
//  BalloonUI
//
//  Created by muukii on 7/24/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

import BalloonUI
import EasyPeasy
import Instantiatable
import ViewSizeCalculator
import Then
import Measure

final class TextMessageRightCell: TextMessageCell, Reusable {
    
    // MARK: - Public
    
    class func sizeForItem(collectionView: UICollectionView, viewModel: TextMessageCellViewModel) -> CGSize {
        
        struct Static {
            static let cal = ViewSizeCalculator(sourceView: TextMessageRightCell(frame: CGRect(x: 0, y: 0, width: 0, height: 0))) { cell in
                return cell.contentView
            }
        }
        
        return Static.cal.calculate(width: collectionView.bounds.width, height: nil, cacheKey: viewModel.cacheKey) { (cell) in
            cell.update(viewModel: viewModel, updateType: .Sizing)            
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        
        self.backgroundColor = UIColor.white
        
        let _label = Balloon().then {
            $0.type = .right
            $0.balloonColor = UIColor(red:0.56, green:0.84, blue:0.92, alpha:1.00)
            $0.preferredMaxLayoutWidth = UIScreen.main.bounds.width - 100
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        contentView.addSubview(_label)
        
        _label <- [
            Top(4),
            Right(4),
            Bottom(4),
            Left(>=0),
        ]
        
        label = _label
    }
}
