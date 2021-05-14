//
//  CityListInteractor.swift
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

protocol CityListBusinessLogic {
    func getCityList()
}

protocol CityListDataStore {
    //var name: String { get set }
}

final class CityListInteractor: CityListBusinessLogic, CityListDataStore {
    var presenter: CityListPresentationLogic? = nil
    
    var viewModel: CityList.CityItemModel?
    
    func getCityList() {
        
        if let url = Bundle.main.url(forResource: "temp", withExtension: "json") {
            do {
                let jsonData = try Data(contentsOf: url)
                parse(jsonData: jsonData)
                print("yesim")
            }
            catch {
                print(error)
            }
        }
    }
    
    private func parse(jsonData: Data) {
        do {
            let cityItemList = try JSONDecoder().decode([CityList.CityItemModel].self, from: jsonData)
            
            presenter?.presentCityList(cityItemList: cityItemList)
            debugPrint("decoded successfully")
        } catch {
            print("error: \(error)")
        }
    }
}
