//
//  CustomTableViewCell.swift
//  SearchingCities
//
//  Created by Yeşim Daşdemir on 13.05.2021.
//

import UIKit

final class CustomTableViewCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    var component: UIView? {
        didSet {
            for view in subviews {
                view.removeFromSuperview()
            }
            
            guard let component = component else {
                return
            }
            self.frame = bounds
            self.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            addSubview(component)
        }
    }
    
}
