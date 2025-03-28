//
//  CCEndpoint.swift
//  CricutDemo
//
//  Created by BB Mete on 3/27/25.
//
import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

protocol CCEndpoint {
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }
}

enum CCAPIEndpoint: CCEndpoint {
    case getButtonsShape
    
    var baseURL: String {
        return "http://staticcontent.cricut.com/static/test/"
    }
    
    var path: String {
        switch self {
        case .getButtonsShape:
            return "shapes_001.json"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getButtonsShape:
            return .get
        }
    }
    
    var headers: [String: String]? {
        return [
            "Content-Type": "application/json"
        ]
    }
}
