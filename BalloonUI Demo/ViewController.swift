//
//  ViewController.swift
//  BalloonUI
//
//  Created by muukii on 07/22/2016.
//  Copyright (c) 2016 muukii. All rights reserved.
//

import UIKit
import Measure
import Instantiatable

class ViewController: UIViewController {
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()        
        collectionView?.registerReusableCell(cellType: TextMessageRightCell.self)
        collectionView?.registerReusableCell(cellType: TextMessageLeftCell.self)

        collectionView?.delegate = self
        collectionView?.dataSource = self
    }
    
    @IBOutlet weak var collectionView: UICollectionView?
    
    lazy var messages: [TextMessageCellViewModel] = Message.importToViewModelFromJSON()
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    private func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
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
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
