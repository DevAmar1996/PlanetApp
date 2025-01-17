//
//  MockNetworkService.swift
//  PlanetsApp
//
//  Created by Qamar Al Amassi on 17/01/2025.
//

import Foundation
import Combine

class MockNetworkService: NetworkService {
    var shouldReturnError: Bool = false
    var data: Data?

    func makeRequest<T>(url: String, httpMethod: HTTPMethod, parameters: [String : Any]?, headers: [String : String]?) -> AnyPublisher<T, any Error> where T : Decodable {
        //check if valid path or not
        if url.isEmpty {
            return Fail(error: URLError(.badURL))
                .eraseToAnyPublisher()
        }
        //check reutrn error scenario
        if shouldReturnError {
            return Fail(error: URLError(.badServerResponse))
                .eraseToAnyPublisher()
        }

        //check data existance
        guard let data = data else {
            //return error in case data not exist
            return Fail(error: URLError(.cannotParseResponse))
                .eraseToAnyPublisher()
        }

        do {
            //try to decode data if sucess return decoded data
            let decodedData = try JSONDecoder().decode(T.self, from: data)
            return Just(decodedData)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        } catch {
            //fail to decode data
            return Fail(error: error)
                .eraseToAnyPublisher()
        }
    }
}
