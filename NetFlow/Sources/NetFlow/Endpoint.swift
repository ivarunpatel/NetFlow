//
//  Endpoint.swift
//
//  Created by Varun on 11/05/23.
//

import Foundation

public enum HTTPMethodType: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

public protocol Requestable {
    var path: String { get }
    var isFullPath: Bool { get }
    var method: HTTPMethodType { get }
    var queryParameters: [String: Any] { get }
    
    func urlRequest(with config: NetworkConfigurable) throws -> URLRequest
}

public enum RequestGenerationError: Error {
    case components
}
extension Requestable {
    func url(with config: NetworkConfigurable) throws -> URL {
        var baseURL = ""
        if #available(iOS 16.0, *) {
            baseURL = isFullPath ? path : config.baseURL.appending(path: path).absoluteString
        } else {
            baseURL = isFullPath ? path : config.baseURL.appendingPathComponent(path).absoluteString
        }
        
        guard var urlComponents = URLComponents(string: baseURL) else {
            throw RequestGenerationError.components
        }
        var urlQueryItems = [URLQueryItem]()
        
        config.queryParameters.forEach {
            urlQueryItems.append(URLQueryItem(name: $0.key, value: $0.value.removingPercentEncoding))
        }
        queryParameters.forEach {
            urlQueryItems.append(URLQueryItem(name: $0.key, value: "\($0.value)"))
        }
        urlComponents.queryItems = urlQueryItems.isEmpty ? nil : urlQueryItems
        guard let url = urlComponents.url else {
            throw RequestGenerationError.components
        }
        return url
    }
    public func urlRequest(with config: NetworkConfigurable) throws -> URLRequest {
        let url = try url(with: config)
        var urlRequest = URLRequest(url: url)
        config.headers.forEach { headerField, value in
            urlRequest.setValue(value, forHTTPHeaderField: headerField)
        }
        urlRequest.httpMethod = method.rawValue
        return urlRequest
    }
}
