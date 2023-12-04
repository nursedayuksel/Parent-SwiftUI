//
//  DeeplinkManager.swift
//  Parent SwiftUI
//
//  Created by Nurseda on 09.10.2023.
//

import Foundation

class DeeplinkManager {
    
    enum DeeplinkTarget: Equatable {
        case home
        case details(reference: String)
    }
    
    class DeepLinkConstants {
        static let scheme = "cws"
        static let host = "com.createwithswift"
        static let detailsPath = "/details"
        static let query = "id"
    }
    
    func manage(url: URL) -> DeeplinkTarget {
        guard url.scheme == DeepLinkConstants.scheme,
              url.host == DeepLinkConstants.host,
              url.path == DeepLinkConstants.detailsPath,
              let components = URLComponents(url: url, resolvingAgainstBaseURL: true),
              let queryItems = components.queryItems
        else { return .home }
        
        let query = queryItems.reduce(into: [String: String]()) { (result, item) in
            result[item.name] = item.value
        }
        
        guard let id = query[DeepLinkConstants.query] else { return .home }
        
        return .details(reference: id)
    }
}
