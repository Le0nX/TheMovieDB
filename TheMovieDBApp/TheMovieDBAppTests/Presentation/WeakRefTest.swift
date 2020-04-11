//
//  WeakRefTest.swift
//  TheMovieDBAppTests
//
//  Created by Denis Nefedov on 26.03.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

@testable import TheMovieDBApp
import XCTest

final class WeakRefTest: XCTestCase {
    
    func test_searchVCmemLeak() {
        let searchVc = MainSearchViewController(imageLoader: ImageLoaderMock())
        let loader = SearchLoaderImpl(searchVc,
                                      favoriteService: ServiceFabric().favoriteService,
                                      moviesService: ServiceFabric().movieService,
                                      accessService: ServiceFabric().accessService)
        searchVc.loader = loader
        
        addTeardownBlock { [weak searchVc] in
            XCTAssertNotNil(searchVc, "Пропускаем утечку")
        }
        
    }
    
    func test_searchVCmemNoLeak() {
        let searchVc = MainSearchViewController(imageLoader: ImageLoaderMock())
        let loader = SearchLoaderImpl(WeakRef(searchVc),
                                      favoriteService: ServiceFabric().favoriteService,
                                      moviesService: ServiceFabric().movieService,
                                      accessService: ServiceFabric().accessService)
        searchVc.loader = loader
        
        trackForMemoryLeaks(searchVc)
        trackForMemoryLeaks(loader)
    }
    
    func test_accountVCmemNoLeak() {
        let serviceFabric = ServiceFabric()
        let accountVc = MainAccountViewController(storyAssembler: StoryFabric(servicesAssembler: serviceFabric))
        let loader = AccountLoaderImpl(WeakRef(accountVc),
                                       credentailsService: serviceFabric.accessService,
                                       profileService: serviceFabric.profileService)
        accountVc.loader = loader
        
        trackForMemoryLeaks(accountVc)
        trackForMemoryLeaks(loader)
    }
    
    func test_accountVCmemLeak() {
        let serviceFabric = ServiceFabric()
        let accountVc = MainAccountViewController(storyAssembler: StoryFabric(servicesAssembler: serviceFabric))
        let loader = AccountLoaderImpl(accountVc,
                                       credentailsService: serviceFabric.accessService,
                                       profileService: serviceFabric.profileService)
        accountVc.loader = loader
        
        addTeardownBlock { [weak accountVc] in
            XCTAssertNotNil(accountVc, "Пропускаем утечку")
        }
        
    }
    
    private final class ImageLoaderMock: ImageLoader {
        func fetchImage(for: String, completion: @escaping (Data?) -> Void) -> UUID? {
            nil
        }
        
        func cancelTask(for poster: UUID) {
            
        }
    }
}
