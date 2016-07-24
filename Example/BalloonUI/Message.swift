//
//  Message.swift
//  BalloonUI
//
//  Created by muukii on 7/24/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Message {
    
    let fromMe: Bool
    let text: String
    
}

extension Message {
    
    static func importFromJSON() -> [Message] {
        
        let path = NSBundle.mainBundle().pathForResource("messages", ofType: "json")!
        let data = NSData(contentsOfFile: path)!        
        let json = JSON(data: data)
        
        return json["data"].arrayValue.map { json -> Message in
            
            Message(fromMe: json["fromMe"].boolValue, text: json["text"].stringValue)            
        }
    }
}
