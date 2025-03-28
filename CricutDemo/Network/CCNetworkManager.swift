//
//  NetworkManager.swift
//  CricutDemo
//
//  Created by BB Mete on 3/27/25.
//

import Foundation

enum CCNetworkError: Error, Equatable {
    case invalidURL
    case invalidResponse
    case decodingError
    case serverError(Int)
    case unknown
}

protocol CCNetworkProtocol {
    func request<T: Decodable>(from endpoint: CCEndpoint) async throws -> T
}

final class CCNetworkManager: CCNetworkProtocol {
    static let shared = CCNetworkManager()
    private let session: URLSession
    
    private init(session: URLSession = .shared) {
        self.session = session
    }
    
    func request<T: Decodable>(from endpoint: CCEndpoint) async throws -> T {
        guard let url = URL(string: endpoint.baseURL + endpoint.path) else {
            throw CCNetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.allHTTPHeaderFields = endpoint.headers
        
        do {
            let (data, response) = try await session.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw CCNetworkError.invalidResponse
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                throw CCNetworkError.serverError(httpResponse.statusCode)
            }
            
            let decoder = JSONDecoder()
            
            return try decoder.decode(T.self, from: data)
        } catch _ as DecodingError {
            throw CCNetworkError.decodingError
        } catch {
            throw CCNetworkError.unknown
        }
    }
}
