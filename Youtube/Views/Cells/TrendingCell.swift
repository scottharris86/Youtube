//
//  TrendingCell.swift
//  Youtube
//
//  Created by scott harris on 1/25/20.
//  Copyright © 2020 scott harris. All rights reserved.
//

import UIKit

class TrendingCell: FeedCell {
    override func fetchVideos() {
        ApiService.sharedInstance.fetchTrendingFeed { (videos: [Video]) in
            self.videos = videos
            self.collectionView.reloadData()
        }
    }
}
