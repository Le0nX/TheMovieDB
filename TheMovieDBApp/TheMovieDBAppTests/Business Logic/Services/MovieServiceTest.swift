//
//  MovieService.swift
//  TheMovieDBAppTests
//
//  Created by Denis Nefedov on 25.03.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

@testable import TheMovieDBApp
@testable import TMDBNetwork
import XCTest

final class MovieServiceTest: XCTestCase {

    func test_emptyRequest() {
        let (client, _) = makeSUT()
        
        XCTAssertTrue(client.urlRequests.isEmpty)
    }
    
    /// Проверка на то, что два вызова подряд будут в правильном кол-ве и порядке
    func test_twiceCall() {
        
        let (client, service) = makeSUT()
        
        let film1 = "film1"
        let film2 = "film2"
        
        service.searchFilm(name: film1) { _ in }
        service.searchFilm(name: film2) { _ in }
        
        let endpoint = SearchFilmEndpoint(search: film1)
        let endpoint2 = SearchFilmEndpoint(search: film2)
        
        XCTAssertEqual(client.urlRequests, [try? endpoint.makeRequest(), try? endpoint2.makeRequest()])
    }
    
    /// Проверка на ответ от APIClient'a о невалидных данных
    func test_onFilmInvalidDataError() {
        let (client, service) = makeSUT()
        let search = "test"
        let endpoint = SearchFilmEndpoint(search: search)
        
        expectSearchFilm(service, toCompleteWith: .failure(APIError.invalidData), when: {
            let clientError = APIError.invalidData
            client.complete(for: endpoint, with: clientError)
        })
    }
    
    /// Проверка маппинга в MovieEntity при пустом results в пришедшем MovieResponse
    func test_onFilmEmptyResultsData() {
        let (client, service) = makeSUT()
        let search = "test"
        let endpoint = SearchFilmEndpoint(search: search)
        
        expectSearchFilm(service, toCompleteWith: .success([]), when: {
            // если нам приходит нормальный респонз с nil в результатах, то мы должны выдать пустой ответ
            let data = MovieResponse(page: 1, results: nil, totalResults: 0, totalPages: 0)
            client.complete(for: endpoint, with: data)
        })
    }
    
    /// Проверка маппинга в MovieEntity при не пустом results в пришедшем MovieResponse
    func test_onFilmResultsData() {
        let (client, service) = makeSUT()
        let search = "test"
        let endpoint = SearchFilmEndpoint(search: search)
        
        let expectedData = MovieEntity(title: "titleTest",
                                       originalTitle: "film",
                                       overview: "adfadf",
                                       popularity: 6.0,
                                       voteCount: 1,
                                       genreIds: nil,
                                       image: nil)
        
        expectSearchFilm(service, toCompleteWith: .success([expectedData]), when: {
            let movie = Movie(posterPath: nil,
                              adult: false,
                              overview: "adfadf",
                              releaseDate: nil,
                              genreIds: nil,
                              originalTitle: "film",
                              originalLanguage: "ru",
                              title: "titleTest",
                              backdropPath: nil,
                              popularity: 6.0,
                              voteCount: 1,
                              video: nil,
                              voteAverage: nil
            )
            let data = MovieResponse(page: 1, results: [movie], totalResults: 0, totalPages: 0)
            client.complete(for: endpoint, with: data)
        })
    }
    
    // MARK: - Private helpers
    
    /// make System Under Test
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (APIClientSpy, MoviesService) {
        let client = APIClientSpy()
        let service = MoviesService(client: client)
        trackForMemoryLeaks(client, file: file, line: line)
        trackForMemoryLeaks(service, file: file, line: line)
        
        return (client, service)
    }
    
    private func expectSearchFilm(_ sut: MoviesService,
                                  toCompleteWith expectedResult: Result<[MovieEntity], Error>,
                                  when action: () -> Void,
                                  file: StaticString = #file,
                                  line: UInt = #line) {
            
        let exp = expectation(description: "Ждем конца загрузки")
        
        sut.searchFilm(name: name) { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.success(receivedItems), .success(expectedItems)):
                XCTAssertEqual(receivedItems, expectedItems, file: file, line: line)
                
            case let (.failure(receivedError as APIError), .failure(expectedError as APIError)):
                XCTAssertEqual(receivedError.localizedDescription,
                               expectedError.localizedDescription,
                               file: file,
                               line: line)
                
            default:
                XCTFail("Ожидали результат \(expectedResult),получили \(receivedResult) вместо", file: file, line: line)
            }
            
            exp.fulfill()
        }
        
        action()
        
        wait(for: [exp], timeout: 1.0)
    }
    
}
