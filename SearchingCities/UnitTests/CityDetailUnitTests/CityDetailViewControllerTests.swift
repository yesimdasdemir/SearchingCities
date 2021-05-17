//
//  CityDetailViewControllerTests.swift
//  SearchingCities
//
//  Created by Yeşim Daşdemir on 15.05.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import XCTest

class CityDetailViewControllerTests: XCTestCase {
    // MARK: Subject under test
    
    var sut: CityDetailViewController!
    var window: UIWindow!
    
    // MARK: Test lifecycle
    
    override func setUp() {
        super.setUp()
        window = UIWindow()
        setupCityDetailViewController()
    }
    
    override func tearDown() {
        window = nil
        super.tearDown()
    }
    
    // MARK: Test setup
    
    func setupCityDetailViewController() {
        let bundle = Bundle.main
        let storyboard = UIStoryboard(name: "CityDetail", bundle: bundle)
        sut = storyboard.instantiateViewController(withIdentifier: "CityDetail") as? CityDetailViewController
    }
    
    func loadView() {
        window.addSubview(sut.view)
        RunLoop.current.run(until: Date())
    }
    
    // MARK: Test doubles
    
    final class CityDetailBusinessLogicSpy: CityDetailBusinessLogic {
        
        
        var getMapViewModelCalled = false
        
        func getMapViewModel() {
            getMapViewModelCalled = true
        }
    }
    
    // MARK: Tests
    
}
