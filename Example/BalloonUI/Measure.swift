//
//  Measure.swift
//  BalloonUI
//
//  Created by muukii on 7/24/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

struct Measure {
    
    let name: String // GAに使う名前
    var time: NSTimeInterval {
        
        return self.endAt.timeIntervalSince1970 - self.startAt.timeIntervalSince1970
    }
    
    init(name: String) {
        
        self.name = name
    }
    
    mutating func start() -> Measure {
        
        self.startAt = NSDate()
        return self
    }
    
    mutating func end() -> Measure {
        
        self.endAt = NSDate()
        print("[Measure] -> \(self.name) : \(self.time) sec")
        return self
    }
    
    static func run(name name: String, @noescape block: () -> Void) -> Measure {
        
        var measure = Measure(name: name)
        measure.start()
        block()
        measure.end()
        
        return measure
    }
    
    private var startAt: NSDate = NSDate(timeIntervalSince1970: 0)
    private var endAt: NSDate = NSDate(timeIntervalSince1970: 0)
}
