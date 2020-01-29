//
//  ApiService.swift
//  Youtube
//
//  Created by scott harris on 1/11/20.
//  Copyright © 2020 scott harris. All rights reserved.
//

import UIKit

class ApiService: NSObject {
    static let sharedInstance = ApiService()
    
    let baseUrl = "https://s3-us-west-2.amazonaws.com/youtubeassets"
    
    func fetchVideos(completion: @escaping ([Video]) -> ()) {
        let url = baseUrl + "/home.json"
        fetchFeedForUrlString(urlString: url, completion: completion)
        
    }
    
    func fetchTrendingFeed(completion: @escaping ([Video]) -> ()) {
        let url = baseUrl + "/trending.json"
        fetchFeedForUrlString(urlString: url, completion: completion)
        
    }
    
    func fetchSubscriptionFeed(completion: @escaping ([Video]) -> ()) {
        let url = baseUrl + "/subscriptions.json"
        fetchFeedForUrlString(urlString: url, completion: completion)
        
    }
    
    func fetchFeedForUrlString(urlString: String, completion: @escaping ([Video]) -> ()) {
        if let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error!)
                    return
                }
                
                do {
                    if let data = data,
                        let jsonDictionaries = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [[String: AnyObject]] {
                        
                        let videos = jsonDictionaries.map({ return Video(dictionary: $0)})
                        
                        DispatchQueue.main.async {
                            completion(videos)
                        }
                    }
                    
                } catch {
                    print(error)
                }
                
                
            }.resume()
        }
        
    }
    
}
