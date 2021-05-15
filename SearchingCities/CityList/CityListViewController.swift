//
//  CityListViewController.swift
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
import MapKit

protocol CityListDisplayLogic: AnyObject {
    func displayCityList(simpleItemModelList: [SimpleItemViewModel], cityItemList: [CityList.CityItemModel])
}

final class CityListViewController: UIViewController, CityListDisplayLogic {
    
    var interactor: CityListBusinessLogic?
    var router: (NSObjectProtocol & CityListRoutingLogic & CityListDataPassing)?
    
    @IBOutlet private var tableView: UITableView!
    private let searchController = UISearchController(searchResultsController: nil)
    private var simpleItemModelList: [SimpleItemViewModel] = []
    private var cityModelList: [CityList.CityItemModel] = []
    private var filtered2Cities: [CityList.CityItemModel] = []
    private var filteredCities: [SimpleItemViewModel] = []
    private var lowerCaseCities: [CityList.CityItemModel] = []
    private let customCellHeight: CGFloat = 70.0
    
    private var lowerSearchText: String {
        return searchController.searchBar.text?.lowercased() ?? ""
    }
    
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    var isFiltering: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }
    
    // MARK: Object lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Setup
    
    private func setup() {
        let viewController = self
        let interactor = CityListInteractor()
        let presenter = CityListPresenter()
        let router = CityListRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        registerTableView()
        setSearchViewController()
        interactor?.getCityList()
    }
    
    private func registerTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "CustomTableViewCell")
    }
    
    private func setSearchViewController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Cities"
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.accessibilityScroll(.down)
        definesPresentationContext = true
    }
    
    private func filterContentForSearchText(_ searchText: String,
                                            category: CityList.CityItemModel? = nil) {
        
        filtered2Cities = cityModelList.filter({ item in
            item.name!.lowercased().contains(searchText.lowercased())
        })
        
        filteredCities = filtered2Cities.map({ item in
            let title: String = item.name! + ", " + item.countryName!
            let subTitle: String = String((item.coordinate?.longitude)!) + ", " + String((item.coordinate?.latitude)!)
            
            return SimpleItemViewModel(id: item.id,
                                       title: title,
                                       subTitle: subTitle)
        })
    }
    
    func displayCityList(simpleItemModelList: [SimpleItemViewModel], cityItemList: [CityList.CityItemModel]) {
        self.simpleItemModelList = simpleItemModelList
        cityModelList = cityItemList
    }
}

extension CityListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isFiltering ? filteredCities.count : cityModelList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell") as? CustomTableViewCell {
            let simpleItemView = SimpleItemView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: customCellHeight))
            simpleItemView.viewModel = isFiltering ? filteredCities[indexPath.row] : simpleItemModelList[indexPath.row]
            cell.component = simpleItemView
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cityViewModel: CityList.CityItemModel = isFiltering ? filtered2Cities[indexPath.row] : cityModelList[indexPath.row]
        let mapViewModel: CityDetail.MapViewModel = getMapViewModel(viewModel: cityViewModel)
        
        router?.routeToCityDetail(viewModel: mapViewModel)
    }
    
    private func getMapViewModel(viewModel: CityList.CityItemModel) -> CityDetail.MapViewModel {
        return CityDetail.MapViewModel(title: viewModel.name ?? "City",
                                       coordinate: CLLocationCoordinate2D(latitude: viewModel.coordinate?.latitude ?? 51.5549,
                                                                          longitude: viewModel.coordinate?.longitude ?? -0.108436),
                                       info: "City Location")
        
    }
    
    func binarySearch<T:Comparable>(_ inputArr:Array<T>, _ searchItem: T) {
        var lowerIndex = 0
        var upperIndex = inputArr.count - 1
        
        while (true) {
            let currentIndex = (lowerIndex + upperIndex)/2
            let value: String = inputArr[currentIndex] as? String ?? ""
            
            if (value.firstIndex(of: searchItem as! String.Element) != nil) {
                
            } else if (lowerIndex > upperIndex) {
            } else {
                if (inputArr[currentIndex] > searchItem) {
                    upperIndex = currentIndex - 1
                } else {
                    lowerIndex = currentIndex + 1
                }
            }
            
            //            filteredCities = cityModelList.filter({ $0.name == inputArr[currentIndex] })
        }
    }
}

extension CityListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
        tableView.reloadData()
    }
}
