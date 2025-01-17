//
//  NetworkService.swift
//  PlanetsApp
//
//  Created by Qamar Al Amassi on 16/01/2025.
//

import Foundation
import Combine

//Protocol for define the main actions for network layer
protocol NetworkService {
    /// Makes an asynchronous network request and decodes the response into a specified type.
    ///
    /// - Parameters:
    ///   - url: the url of the endpoint as `string`.
    ///   - httpMethod: the http method used for the request (eg. POST, GET...).
    ///   - parametes: An optional dictionary containing request parameters.
    ///   - header: An optional dictionary of HTTP headers to include in the request (eg. Authoriztion, Content-Type).
    /// - Returns: A `Combine` publisher (`AnyPublisher<T, Error>`) that contain a decoded object of type `T` conforming to the `Decodable` protocol, or an error if the operation fails.
    /// - Throws: Throws: NetworkError for invalid URLs, missing data, decoding failures, or any network issues
    ///
    func makeRequest<T: Decodable>(url: String,
                                   httpMethod: HTTPMethod,
                                   parameters: [String: Any]?,
                                   headers: [String: String]?) -> AnyPublisher<T, Error>
}

extension NetworkService {
    /// provide make request with optional header and paramerer
    /// This allows you to make simple requests without explicitly passing `nil` for unused arguments.
    func makeRequest<T: Decodable>(url: String,
                                   httpMethod: HTTPMethod,
                                   parameters: [String: Any]? = nil,
                                   headers: [String: String]? = nil) -> AnyPublisher<T, Error> {
        return self.makeRequest(url: url, httpMethod: httpMethod, parameters: parameters, headers: headers)
    }
}
