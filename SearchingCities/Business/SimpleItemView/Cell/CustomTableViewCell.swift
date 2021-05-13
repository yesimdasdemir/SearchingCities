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
            removeFromSuperview()
            
            guard let component = component else {
                return
            }
            
            addSubview(component)
        }
    }

}
