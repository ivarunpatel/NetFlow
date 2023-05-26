//
//  URLSessionHTTPClient.swift
//
//  Created by Varun on 11/05/23.
//

import Foundation

public final class URLSessionHTTPClient: HTTPClient {
    private let networkConfigurable: NetworkConfigurable
    private let session: URLSession
    
    public init(networkConfigurable: NetworkConfigurable, session: URLSession = .shared) {
        self.networkConfigurable = networkConfigurable
        self.session = session
    }
    
    public func execute(request: Requestable) async throws -> (Data, URLResponse) {
        let urlRequest = try request.urlRequest(with: networkConfigurable)
        return try await session.data(for: urlRequest)
    }
}
