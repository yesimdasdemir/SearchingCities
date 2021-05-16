//
//  SimpleItemViewModel.swift
//  SearchingCities
//
//  Created by Yeşim Daşdemir on 13.05.2021.
//

import Foundation
import UIKit

struct SimpleItemViewModel {
    let id: Int?
    let title: String?
    let subTitle: String?
    
    init(id: Int? = nil, title: String? = nil, subTitle: String? = nil) {
        self.id = id
        self.title = title
        self.subTitle = subTitle
    }
}

struct ContentViewModel {
    let borderWidth: CGFloat?
    let borderColor: CGColor?
    let cornerRadius: CGFloat?
    let leadingTrailingPadding: CGFloat?
    let topBottomPadding: CGFloat?
    
    init(borderWidth: CGFloat? = nil,
         borderColor: CGColor? = nil,
         cornerRadius: CGFloat? = nil,
         leadingTrailingPadding: CGFloat? = nil,
         topBottomPadding: CGFloat? = nil) {
        
        self.borderWidth = borderWidth
        self.borderColor = borderColor
        self.cornerRadius = cornerRadius
        self.leadingTrailingPadding = leadingTrailingPadding
        self.topBottomPadding = topBottomPadding
    }
}

