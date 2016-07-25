//
//  ViewController.swift
//  BalloonUI
//
//  Created by muukii on 07/22/2016.
//  Copyright (c) 2016 muukii. All rights reserved.
//

import UIKit
import Measure

class ViewController: UIViewController {
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.registerReusableCell(TextMessageRightCell)
        collectionView.registerReusableCell(TextMessageLeftCell)

        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    @IBOutlet private weak var collectionView: UICollectionView!
    
    lazy var messages: [TextMessageCellViewModel] = Message.importToViewModelFromJSON()
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        var measure = Measure(name: ", Normal, ", threshold: 0.005)
        measure.start()
        
        defer {
            measure.end()
        }
        
        let message = messages[indexPath.item]
        
        if message.message.fromMe {
            
            let cell = collectionView.dequeueReusableCell(indexPath: indexPath, cellType: TextMessageRightCell.self)
            
            cell.update(viewModel: message, updateType: .Normal)
            return cell
        }
        else {
            
            let cell = collectionView.dequeueReusableCell(indexPath: indexPath, cellType: TextMessageLeftCell.self)
            
            cell.update(viewModel: message, updateType: .Normal)
            return cell
        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        var measure = Measure(name: ", Sizing, ", threshold: 0.005)
        measure.start()
        
        defer {
            measure.end()
        }
        
        let message = messages[indexPath.item]

        if message.message.fromMe {
            return TextMessageRightCell.sizeForItem(collectionView: collectionView, viewModel: message)
        }
        else {
            return TextMessageLeftCell.sizeForItem(collectionView: collectionView, viewModel: message)
        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsZero
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
}
