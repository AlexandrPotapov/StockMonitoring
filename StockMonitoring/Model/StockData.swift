//
//  StockData.swift
//  StockMonitoring
//
//  Created by Александр on 27.03.2021.
//

import Foundation

struct Stocks {
    let stocks: [StockQuote?]
}

struct StockQuote: Decodable {
    let symbol: String?
    let shortName: String?
    let postMarketPrice: Double?
    let regularMarketChange: Double?
    let regularMarketChangePercent: Double?
}

struct MostWatchedTickers: Decodable {
    let count: Int?
    let quotes: [String]
}

struct NewsCompany: Decodable {
    let item : [NewsData]?
}

struct NewsData: Decodable {
    let description: String?
    let guid: String?
    let link: String?
    let pubDate: String?
    let title: String?
    
}

struct QuoteHistory: Decodable {
    let meta: MetaData?
    let items: [String : HistoricData]
    let error: String? // если что убрать
}

struct MetaData: Decodable {
    let symbol: String?
    let dataGranularity: String?
}

struct HistoricData: Decodable {
    let date: String?
    let open: Double?
    let high: Double?
    let low: Double?
    let close: Double?
}

