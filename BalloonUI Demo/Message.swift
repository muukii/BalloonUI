//
//  Message.swift
//  BalloonUI
//
//  Created by muukii on 7/24/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation
import JAYSON

struct Message {
    
    let fromMe: Bool
    let text: String
    
}

extension Message {
    
    static func importFromJSON() -> [Message] {
        
        let path = Bundle.main.path(forResource: "messages", ofType: "json")!
        let data = try! Data(contentsOf: URL(fileURLWithPath: path))
        let json = try! JAYSON(data: data)
        
        return try! json.next("data").getArray().map { json -> Message in
            
            Message(fromMe: try! json.next("fromMe").getBool(), text: try! json.next("text").getString())
        }
    }
    
    static func importToViewModelFromJSON() -> [TextMessageCellViewModel] {
        
        let path = Bundle.main.path(forResource: "messages", ofType: "json")!
        let data = try! Data(contentsOf: URL(fileURLWithPath: path))
        let json = try! JAYSON(data: data)
        
        return try! json.next("data").getArray().map { json -> TextMessageCellViewModel in
            
            TextMessageCellViewModel(message:
                Message(fromMe: try! json.next("fromMe").getBool(), text: try! json.next("text").getString())
            )
        }
    }
}
