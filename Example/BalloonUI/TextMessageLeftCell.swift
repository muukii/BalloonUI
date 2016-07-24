//
//  TextMessageLeftCell.swift
//  BalloonUI
//
//  Created by muukii on 7/24/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation


import BalloonUI

import Cartography
import Reusable
import ViewSizeCalculator
import Then

final class TextMessageLeftCell: UICollectionViewCell, Reusable {
    
    // MARK: - Public
    
    class func sizeForItem(collectionView collectionView: UICollectionView, viewModel: TextMessageCellViewModel) -> CGSize {
        
        struct Static {
            static let cal = ViewSizeCalculator(sourceView: TextMessageLeftCell(frame: CGRect(x: 0, y: 0, width: 0, height: 0))) { cell in
                return cell.contentView
            }
        }
        
        return Static.cal.calculate(width: collectionView.bounds.width, height: nil, cacheKey: viewModel.cacheKey) { (cell) in
            cell.update(viewModel: viewModel)
        }
    }
    
    func update(viewModel viewModel: TextMessageCellViewModel) {
        
        label?.attributedText = viewModel.attributedText
        contentView.invalidateIntrinsicContentSize()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        label?.attributedText = nil
    }
    
    override func layoutSublayersOfLayer(layer: CALayer) {
        super.layoutSublayersOfLayer(layer)
    }
    
    func setup() {
        
        self.backgroundColor = UIColor.whiteColor()
        
        let _label = BalloonLabel().then {
            $0.type = .Left
            $0.balloonColor = UIColor(red:0.88, green:0.26, blue:0.35, alpha:1.00)
            $0.preferredMaxLayoutWidth = UIScreen.mainScreen().bounds.width - 100
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        contentView.addSubview(_label)
        
        constrain(_label) { label in
            
            let superview = label.superview!
            label.left == superview.left + 4
            label.right <= superview.right
            label.top == superview.top + 4
            label.bottom == superview.bottom - 4
        }
        
        label = _label
    }
    
    weak var label: BalloonLabel!
    weak var profileImageView: UIImageView!
}
