//
//  SearchManager.swift
//  SearchingCities
//
//  Created by Yeşim Daşdemir on 17.05.2021.
//

import Foundation

final class SearchManager {
    
    private var cityItemModel: [CityList.CityItemModel] = []
    private var searchText: String = ""
    var cities: [String] = []
    private var filterStart: Int = 0
    private var filterEnd: Int = 0
    
     init() {
        if let url = Bundle.main.url(forResource: "cities", withExtension: "json") {
            do {
                let jsonData = try Data(contentsOf: url)
                
                cityItemModel = parse(jsonData: jsonData)
                
                cityItemModel = cityItemModel.sorted {
                    guard let first = $0.name else {
                        return false
                    }
                    
                    guard let second = $1.name else {
                        return true
                    }
                    
                    return first.localizedCaseInsensitiveCompare(second) == ComparisonResult.orderedAscending
                }
                
                cities = cityItemModel.map( {$0.name ?? ""} )
            }
            catch {
                print(error)
            }
        }
        
        
        filterStart = 0
        filterEnd = cityItemModel.count - 1
    }
    
    private func parse(jsonData: Data) -> [CityList.CityItemModel] {
        do {
            debugPrint("decoded successfully")
            return  try JSONDecoder().decode([CityList.CityItemModel].self, from: jsonData)
        } catch {
            print("error: \(error)")
            return []
        }
    }
    
    func filteredCityCount() -> Int {
        if filterStart == -1 {
            return 0
        }
        
        return filterEnd - filterStart + 1
    }
    
    func filteredCitiesAtIndex(index: Int) -> SimpleItemViewModel {
        let filteredCities = Array(cityItemModel[filterStart..<filterEnd + 1])
        
        return mapModel(item: filteredCities[index])
    }
    
    private func mapModel(item: CityList.CityItemModel) -> SimpleItemViewModel {
        var title: String = ""
        var subTitle: String = ""
        
            if let name: String = item.name, let countyName: String = item.countryName {
                title = name + ", " + countyName
            }
            
            if let latitude: Double = item.coordinate?.latitude, let longitude: Double = item.coordinate?.longitude {
                subTitle = String(latitude) + ", " + String(longitude)
            }
            
            return SimpleItemViewModel(id: item.id,
                                       title: title,
                                       subTitle: subTitle)
    }
    
    func binarySearchLast(array: [String], target: String) -> Int {
        var left = 0
        var right = array.count - 1
        
        while (left <= right) {
            let mid = (left + right) / 2
            let value = array[mid]
            
            if (left == right && value.lowercased().hasPrefix(target.lowercased())) {
                return left
            }
            
            if value.hasPrefix(target) {
                if mid < array.count - 1 {
                    if !array[mid + 1].lowercased().hasPrefix(target.lowercased()) {
                        return mid
                    }
                }
                
                left = mid + 1
            } else if (value < target) {
                left = mid + 1
            } else if (value > target) {
                right = mid - 1
            }
        }
        
        return -1
    }
    
    func binarySearchFirst(array: [String], target: String) -> Int {
        var left = 0
        var right = array.count - 1
        
        while (left <= right) {
            let mid = (left + right) / 2
            let value = array[mid]
            
            if (left == right && value.lowercased().hasPrefix(target.lowercased())) {
                return left
            }
            
            if value.hasPrefix(target) {
                if mid > 0 {
                    if !array[mid - 1].lowercased().hasPrefix(target.lowercased()) {
                        return mid
                    }
                }
                right = mid - 1
            } else if (value < target) {
                left = mid + 1
            } else if (value > target) {
                right = mid - 1
            }
        }
        
        return -1
    }
    
    
    func updateFilter(filter: String) {
        searchText = filter
        
        if filter == "" {
            filterStart = 0
            filterEnd = cities.count - 1
            return
        }
        
        filterStart = binarySearchFirst(array: cities, target: filter)
        filterEnd = binarySearchLast(array: cities, target: filter)
    }
}
