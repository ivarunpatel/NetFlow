//
//  HTTPClient.swift
//
//  Created by Varun on 11/05/23.
//

import Foundation

public protocol HTTPClient {
    func execute(request: Requestable) async throws -> (Data, URLResponse)
}
