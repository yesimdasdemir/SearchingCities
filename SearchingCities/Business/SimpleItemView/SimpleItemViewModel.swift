//
//  SimpleItemViewModel.swift
//  SearchingCities
//
//  Created by Yeşim Daşdemir on 13.05.2021.
//

import Foundation

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
