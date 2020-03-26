//
//  WeakRefTest.swift
//  TheMovieDBAppTests
//
//  Created by Denis Nefedov on 26.03.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import TheMovieDBApp
import XCTest

final class WeakRefTest: XCTestCase {
    
    func test_searchVCmemLeak() {
        let searchVc = SearchViewController()
        let presenter = SearchPresenter(searchVc, moviesService: ServiceFabric().movieService)
        searchVc.output = presenter
        
        addTeardownBlock { [weak searchVc] in
            XCTAssertNotNil(searchVc, "Пропускаем утечку")
        }
        
    }
    
    func test_searchVCmemNoLeak() {
        let searchVc = SearchViewController()
        let presenter = SearchPresenter(WeakRef(searchVc), moviesService: ServiceFabric().movieService)
        searchVc.output = presenter
        
        trackForMemoryLeaks(searchVc)
        trackForMemoryLeaks(presenter)
    }
    
    func test_accountVCmemNoLeak() {
        let accountVc = AccountViewController()
        let presenter = AccountPresenter(WeakRef(accountVc),
                                         credentailsService: ServiceFabric().accessService,
                                         profileService: ServiceFabric().profileService,
                                         accountCoordinator: AccountCoordinator(storyAssembler:
                                         StoryFabric(servicesAssembler: ServiceFabric())))
        accountVc.output = presenter
        
        trackForMemoryLeaks(accountVc)
        trackForMemoryLeaks(presenter)
    }
    
    func test_accountVCmemLeak() {
        let accountVc = AccountViewController()
        let presenter = AccountPresenter(accountVc,
                                         credentailsService: ServiceFabric().accessService,
                                         profileService: ServiceFabric().profileService,
                                         accountCoordinator: AccountCoordinator(storyAssembler:
                                         StoryFabric(servicesAssembler: ServiceFabric())))
        accountVc.output = presenter
        
        addTeardownBlock { [weak accountVc] in
            XCTAssertNotNil(accountVc, "Пропускаем утечку")
        }
        
    }
}
