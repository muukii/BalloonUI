//
//  ViewController.swift
//  BalloonUI
//
//  Created by muukii on 07/22/2016.
//  Copyright (c) 2016 muukii. All rights reserved.
//

import UIKit

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
    
    lazy var messages: [Message] = Message.importFromJSON()
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let message = messages[indexPath.item]
        
        if message.fromMe {
            
            let cell = collectionView.dequeueReusableCell(indexPath: indexPath, cellType: TextMessageRightCell.self)
            
            cell.update(viewModel: TextMessageCellViewModel(message: message))
            return cell
        }
        else {
            
            let cell = collectionView.dequeueReusableCell(indexPath: indexPath, cellType: TextMessageLeftCell.self)
            
            cell.update(viewModel: TextMessageCellViewModel(message: message))
            return cell
        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let message = messages[indexPath.item]

        if message.fromMe {
            return TextMessageRightCell.sizeForItem(collectionView: collectionView, viewModel: TextMessageCellViewModel(message: message))
        }
        else {
            return TextMessageLeftCell.sizeForItem(collectionView: collectionView, viewModel: TextMessageCellViewModel(message: message))
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
