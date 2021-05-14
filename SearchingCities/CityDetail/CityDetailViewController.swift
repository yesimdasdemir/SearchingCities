//
//  CityDetailViewController.swift
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

protocol CityDetailDisplayLogic: AnyObject {
    func displayCityDetail(with viewModel: CityDetail.MapViewModel?)
}

final class CityDetailViewController: UIViewController, CityDetailDisplayLogic, CLLocationManagerDelegate, MKMapViewDelegate {
    var interactor: CityDetailBusinessLogic?
    var router: (NSObjectProtocol & CityDetailRoutingLogic & CityDetailDataPassing)?
    
    @IBOutlet private weak var mapView: MKMapView!
    
    private var mapViewModel: CityDetail.MapViewModel?
    private let locationManager = CLLocationManager()
    
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
        let interactor = CityDetailInteractor()
        let presenter = CityDetailPresenter()
        let router = CityDetailRouter()
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
        
        interactor?.getMapViewModel()
        navigationItem.title = mapViewModel?.title ?? "City's Location"
        mapEntegration()
    }
    
    func displayCityDetail(with viewModel: CityDetail.MapViewModel?) {
        mapViewModel = viewModel
    }
    
    private func mapEntegration() {
        if let mapViewModel = mapViewModel {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            mapView.addAnnotation(mapViewModel)
            
            if CLLocationManager.locationServicesEnabled() {
                checkAuthorizationStatus()
                
                mapView.centerToLocation(CLLocation(latitude: mapViewModel.coordinate.latitude, longitude: mapViewModel.coordinate.longitude))
            }
        }
    }
    
    private func checkAuthorizationStatus() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            mapView.showsUserLocation = true
        case .denied:
            let alertController = UIAlertController(title: "Error", message: "You should allow setting to see location.", preferredStyle: .alert)
            //            let okButton = UIAlertAction(title: "Go to Settings", style: .default, handler: { _ in
            //                                            UIApplication.shared.open(URL(string:UIApplication.openSettingsURLString)!)})
            
            let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: { [weak self] _ in
                                                self?.navigationController?.popViewController(animated: true)})
            
            
            //            alertController.addAction(okButton)
            alertController.addAction(cancelButton)
            //            alertController.view.layoutIfNeeded()
            //            alertController.view.snapshotView(afterScreenUpdates: true)
            present(alertController, animated: true, completion: nil)
        default:
            break
        }
    }
}

private extension MKMapView {
    func centerToLocation(_ location: CLLocation, regionRadius: CLLocationDistance = 1000) {
        let coordinateRegion = MKCoordinateRegion(
            center: location.coordinate,
            latitudinalMeters: regionRadius,
            longitudinalMeters: regionRadius)
        setRegion(coordinateRegion, animated: true)
    }
}
