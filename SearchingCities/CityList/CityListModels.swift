//
//  CityListModels.swift
//  SearchingCities
//
//  Created by Yeşim Daşdemir on 13.05.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

enum CityList {
    struct CityItemModel: Codable {
        let id: Int?
        let name: String?
        let countryName: String?
        let coordinate: CoordinateModel?
        
        init(id: Int? = nil, name: String? = nil, countryName: String? = nil, coordinate: CoordinateModel? = nil) {
            self.id = id
            self.name = name
            self.countryName = countryName
            self.coordinate = coordinate
        }
        
        private enum CodingKeys: String, CodingKey {
            case id = "_id"
            case name
            case countryName = "country"
            case coordinate = "coord"
        }
    }
}

struct CoordinateModel: Codable {
    let latitude: Double?
    let longitude: Double?
    
    private enum CodingKeys: String, CodingKey {
        case latitude = "lat"
        case longitude = "lon"
    }
}
