//
//  BaseCell.swift
//  Youtube
//
//  Created by scott harris on 1/2/20.
//  Copyright © 2020 scott harris. All rights reserved.
//

import UIKit

class BaseCell: UICollectionViewCell {
    override init(frame: CGRect) {
           super.init(frame: frame)
           setupViews()
       }
    
    func setupViews() {
        
    }
       
   required init?(coder: NSCoder) {
       fatalError("init(coder:) has not been implemented")
   }
}
