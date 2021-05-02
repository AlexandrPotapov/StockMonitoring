//
//  StockData.swift
//  StockMonitoring
//
//  Created by Александр on 27.03.2021.
//

import Foundation


struct StockQuote: Decodable {
    let symbol: String?
    let shortName: String?
    let regularMarketPrice: Double?
    let regularMarketChange: Double?
    let regularMarketChangePercent: Double?
}

struct Collections: Decodable {
    let start: Int
    let count: Int
    let total: Int
    let description: String
    let quotes: [StockQuote]
}

struct StockSearch: Decodable {
    let count: Int
    let result: [SearchResult]
}

struct SearchResult: Decodable, Equatable {
    let description: String
    let symbol: String
    let type: String
    
    static func == (lhs: SearchResult, rhs: SearchResult) -> Bool {
        return lhs.description == rhs.description
    }
}



