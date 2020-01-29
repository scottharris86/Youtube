//
//  Extenstions.swift
//  Youtube
//
//  Created by scott harris on 12/31/19.
//  Copyright © 2019 scott harris. All rights reserved.
//

import UIKit


// MARK: Helper Method to have view controller based statusbar style if wanted.
extension UINavigationController {
    open override var childForStatusBarStyle: UIViewController? {
        return topViewController?.childForStatusBarStyle ?? topViewController
    }
    
    open override var childForStatusBarHidden: UIViewController? {
        return topViewController?.childForStatusBarHidden ?? topViewController
    }
}

let imageCache = NSCache<NSString, AnyObject>()

class CustomImageView: UIImageView {
    
    var imageURLString: String?
    
    func loadImageUsingURLString(urlString: String) {
        
        imageURLString = urlString
        
        image = nil
        
        if let imageFromCache = imageCache.object(forKey: NSString(string: urlString)) as? UIImage {
            self.image = imageFromCache
            return
        }
        
        if let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                
                DispatchQueue.main.async {
                    let imageToCache = UIImage(data: data!)
                    
                    if self.imageURLString == urlString {
                        self.image = imageToCache
                    }
                    
                    imageCache.setObject(imageToCache!, forKey: NSString(string: urlString))
                    
        
                }
                
            }.resume()
        }
            
    }
}
