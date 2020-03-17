//
//  APIClientConfig.swift
//  TMDBNetwork
//
//  Created by Denis Nefedov on 17.03.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import Foundation

public struct APIClientConfig {
    let session: URLSession
    let baseUrl: String
    
    public init(session: URLSession = URLSession(configuration: .ephemeral), base: String) {
        self.session = session
        self.baseUrl = base
    }
}
