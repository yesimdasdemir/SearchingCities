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
    func displayCityList(simpleItemModelList: [SimpleItemViewModel], cityItemList: [CityList.CityItemModel], contentViewModel: ContentViewModel?)
}

final class CityListViewController: UIViewController, CityListDisplayLogic {
    
    var interactor: CityListBusinessLogic?
    var router: (NSObjectProtocol & CityListRoutingLogic & CityListDataPassing)?
    
    @IBOutlet var tableView: UITableView!
    private let searchController = UISearchController(searchResultsController: nil)
    private(set) var simpleItemModelList: [SimpleItemViewModel] = []
    private var contentViewModel: ContentViewModel?
    private var cityModelList: [CityList.CityItemModel] = []
    private let customCellHeight: CGFloat = 70.0
    
    private(set) var searchManager = SearchManager()

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
    
    func registerTableView() {
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
    
    func displayCityList(simpleItemModelList: [SimpleItemViewModel], cityItemList: [CityList.CityItemModel], contentViewModel: ContentViewModel?) {
        self.simpleItemModelList = simpleItemModelList
        cityModelList = cityItemList
        self.contentViewModel = contentViewModel
    }
}

extension CityListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isFiltering ? searchManager.filteredCityCount() : cityModelList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell") as? CustomTableViewCell {
            let simpleItemView = SimpleItemView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: customCellHeight))
            simpleItemView.contentViewModel = contentViewModel
            simpleItemView.viewModel = isFiltering ? searchManager.filteredCitiesAtIndex(index: indexPath.row) : simpleItemModelList[indexPath.row]
            
            cell.component = simpleItemView
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cityViewModel: CityList.CityItemModel = isFiltering ? searchManager.filteredCitiesAtIndex(index: indexPath.row) : cityModelList[indexPath.row]
        let mapViewModel: CityDetail.MapViewModel = getMapViewModel(viewModel: cityViewModel)

        router?.routeToCityDetail(viewModel: mapViewModel)
    }
    
    private func getMapViewModel(viewModel: CityList.CityItemModel) -> CityDetail.MapViewModel {
        return CityDetail.MapViewModel(title: viewModel.name ?? "City",
                                       coordinate: CLLocationCoordinate2D(latitude: viewModel.coordinate?.latitude ?? 51.5549,
                                                                          longitude: viewModel.coordinate?.longitude ?? -0.108436),
                                       info: "City Location")
        
    }
}

extension CityListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        searchManager.updateFilter(filter: searchBar.text ?? "")
        tableView.reloadData()
    }
}
