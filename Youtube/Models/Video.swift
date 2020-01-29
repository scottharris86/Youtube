//
//  Video.swift
//  Youtube
//
//  Created by scott harris on 1/2/20.
//  Copyright © 2020 scott harris. All rights reserved.
//

import UIKit

class SafeJsonObject: NSObject {
    override func setValue(_ value: Any?, forKey key: String) {
        
        let uppercasedFirstCharacter = key.first!.uppercased()
        
        let range = key.startIndex...key.startIndex.samePosition(in: key)!
        
        let selectorString = key.replacingCharacters(in: range, with: uppercasedFirstCharacter)
        let selector = NSSelectorFromString("set\(selectorString):")
        let responds = self.responds(to: selector)
        
        if !responds {
            return
        }
        
        super.setValue(value, forKey: key)
        
    }
}

class Video: SafeJsonObject {
    @objc var thumbnail_image_name: String?
    @objc var title: String?
    @objc var number_of_views: NSNumber?
    @objc var uploadDate: NSDate?
    @objc var duration: NSNumber?
    
    @objc var channel: Channel?
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "channel" {
            self.channel = Channel()
            channel?.setValuesForKeys(value as! [String: AnyObject])
            
        } else {
           super.setValue(value, forKey: key)
        }
    }
    
    init(dictionary: [String: AnyObject]) {
        super.init()
        setValuesForKeys(dictionary)
    }
    
}

class Channel: SafeJsonObject {
    @objc var name: String?
    @objc var profile_image_name: String?
    
}
