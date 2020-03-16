//
//  Endpoint.swift
//  TheMovieDBApp
//
//  Сетевой слой, написанный на основе
//  https://medium.com/flawless-app-stories/writing-network-layer-in-swift-protocol-oriented-approach-4fa40ef1f908
//
//  Created by Denis Nefedov on 09.03.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import Foundation

///protocol Endpoint для создания request'a и парсинга имеет associatedtype Response
public protocol Endpoint {
    
    // MARK: - Types
    
    associatedtype Content
    
    // MARK: - Public Properties
    
    var path: String { get }
    var headers: [String: String]? { get }
    var params: [String: Any]? { get }
    var parameterEncoding: ParameterEnconding { get }
    var method: HTTPMethod { get }
    
    // MARK: - Public methods
    
    ///Функция для создания запроса
    ///
    /// - Throws: error если запрос не может быть создан
    ///
    /// - Returns: возвращает URLRequest.
    func makeRequest() throws -> URLRequest
    
    /// Функция для парсинга контента
    /// 
    /// - Parameter data: данные, которые пришли по сети
    /// - Parameter response: ответ, который пришел от сервера
    ///
    /// - Returns: результат парсинга
    func content(from data: Data, response: URLResponse?) throws -> Content
}
