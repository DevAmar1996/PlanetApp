//
//  URLSessionNetworkService.swift
//  PlanetsApp
//
//  Created by Qamar Al Amassi on 16/01/2025.
//

import Foundation
import Combine

struct URLSessionNetworkService: NetworkService {
    func makeRequest<T: Decodable>(url: String,
                                   httpMethod: HTTPMethod,
                                   parameters: [String : Any]?,
                                   headers: [String : String]?) -> AnyPublisher<T, Error> {
        let session = URLSession.shared
        //check if it is valid url
        guard let url = URL(string: url) else {
            return Fail(error: NetworkError.invalidURL).eraseToAnyPublisher()
        }

        //prepare the request
        var request = URLRequest(url: url)
        //set rqeust httpMethod
        request.httpMethod = httpMethod.rawValue

        //add headers
        headers?.forEach {
            request.addValue($1, forHTTPHeaderField: $0)
        }

        //Encode parameters
        if let parameters = parameters {
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: [])
                request.httpBody = jsonData
            } catch {
                //return error
                return Fail(error: NetworkError.invalidParameter(params: parameters)
                ).eraseToAnyPublisher()
            }
        }

        return session.dataTaskPublisher(for: request)
            .tryMap { output in
                print("OUTPUT is \(output)")
                // Check the status code
                guard let httpResponse = output.response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    throw NetworkError.requestFailed(statusCode: (output.response as? HTTPURLResponse)?.statusCode ?? -1, message: "invalid request")
                }
                return output.data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
