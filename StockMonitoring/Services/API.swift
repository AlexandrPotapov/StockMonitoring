//
//  API.swift
//  VKNewsFeed
//
//  Created by Алексей Пархоменко on 06/03/2019.
//  Copyright © 2019 Алексей Пархоменко. All rights reserved.
//

import Foundation

struct API {
    static let scheme = "https"
    static let host = "mboum.com"
}

enum EndPoint: String {
    case quote = "/qu/quote/"
    case trending = "/tr/trending"
    case news = "/ne/news/"
    case history = "/hi/history"
    case collections = "/co/collections"
    
    case search = "/search"
}

struct ApiFinnhub {
    static let scheme = "https"
    static let host = "finnhub.io"
}

