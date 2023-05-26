//
//  NetworkConfigurable.swift
//
//  Created by Varun on 11/05/23.
//

import Foundation

public protocol NetworkConfigurable {
    var baseURL: URL { get }
    var headers: [String: String] { get }
    var queryParameters: [String: String] { get }
}
