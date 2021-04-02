//
//  NetworkDataFetcher.swift
//  VKNewsFeed
//
//  Created by Алексей Пархоменко on 09/03/2019.
//  Copyright © 2019 Алексей Пархоменко. All rights reserved.
//

import Foundation

protocol DataFetcher {
    func getMostWatchedResponse(response: @escaping ([MostWatchedTickers]?) -> Void)
    func getQuoteResponse(value: String, response: @escaping ([StockQuote]?) -> Void)
    func getNewsResponse(symbol: String, response: @escaping (NewsCompany?) -> Void)
    func getHistoryResponse(symbol: String, interval: String, diffAndSplits: String, response: @escaping (QuoteHistory?) -> Void)
}

struct NetworkDataFetcher: DataFetcher {
    
    let networking: Networking
    
    init(networking: Networking) {
        self.networking = networking
    }
    
    func getMostWatchedResponse(response: @escaping ([MostWatchedTickers]?) -> Void) {
        
        let params = [String: String]()
        networking.request(path: EndPoint.trending.rawValue, params: params) { (data, error) in
            if let error = error {
                print("Error received requesting data: \(error.localizedDescription)")
                response(nil)
            }
            guard let data = data else { return }
            print(111)
            let decoded = self.decodeJSON(type: [MostWatchedTickers].self, from: data)
//            print(decoded?.count)
            response(decoded)
        }
    }
    
    func getQuoteResponse(value: String, response: @escaping ([StockQuote]?) -> Void) {
        
        let params = ["symbol": value]
        networking.request(path: EndPoint.quote.rawValue, params: params) { (data, error) in
            if let error = error {
                print("Error received requesting data: \(error.localizedDescription)")
                response(nil)
            }
            guard let data = data else { return }
            
            let decoded = self.decodeJSON(type: [StockQuote].self, from: data)
            response(decoded)
        }
    }
    
    func getNewsResponse(symbol: String, response: @escaping (NewsCompany?) -> Void) {
        
        let params = ["symbol": symbol]
        networking.request(path: EndPoint.news.rawValue, params: params) { (data, error) in
            if let error = error {
                print("Error received requesting data: \(error.localizedDescription)")
                response(nil)
            }
            guard let data = data else { return }
            
            let decoded = self.decodeJSON(type: NewsCompany.self, from: data)
            response(decoded)
        }
        
    }
    
    func getHistoryResponse(symbol: String, interval: String, diffAndSplits: String, response: @escaping (QuoteHistory?) -> Void) {
        
        let params = ["symbol": symbol, "interval": interval, "diffandsplits": diffAndSplits]
        networking.request(path: EndPoint.history.rawValue, params: params) { (data, error) in
            if let error = error {
                print("Error received requesting data: \(error.localizedDescription)")
                response(nil)
            }
            guard let data = data else { return }
            
            let decoded = self.decodeJSON(type: QuoteHistory.self, from: data)
            response(decoded)
        }
        
    }
    
    private func decodeJSON<T: Decodable>(type: T.Type, from: Data?) -> T? {
        let decoder = JSONDecoder()
        guard let data = from, let response = try? decoder.decode(type.self, from: data) else { return nil }
        return response
    }
}
