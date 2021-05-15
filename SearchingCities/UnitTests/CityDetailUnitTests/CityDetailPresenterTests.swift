//
//  CityDetailPresenterTests.swift
//  SearchingCities
//
//  Created by Yeşim Daşdemir on 15.05.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

@testable import SearchingCities
import XCTest

class CityDetailPresenterTests: XCTestCase {
    // MARK: Subject under test
    
    var sut: CityDetailPresenter!
    
    // MARK: Test lifecycle
    
    override func setUp() {
        super.setUp()
        setupCityDetailPresenter()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: Test setup
    
    func setupCityDetailPresenter() {
        sut = CityDetailPresenter()
    }
    
    // MARK: Test doubles
    
    class CityDetailDisplayLogicSpy: CityDetailDisplayLogic {
        
        var displayCityDetailCalled = false
        
        func displayCityDetail(with viewModel: CityDetail.MapViewModel?) {
            displayCityDetailCalled = true
        }
    }
    
    // MARK: Tests
    
    func testPresentSomething() {
        // Given
        let spy = CityDetailDisplayLogicSpy()
        sut.viewController = spy
        
        // When
        
        // Then
    }
}
