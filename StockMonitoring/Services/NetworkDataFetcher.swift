//
//  NetworkDataFetcher.swift
//  VKNewsFeed
//
//  Created by Алексей Пархоменко on 09/03/2019.
//  Copyright © 2019 Алексей Пархоменко. All rights reserved.
//

import Foundation

protocol DataFetcher {
    func getQuoteResponse(value: String, response: @escaping ([StockQuote]?) -> Void)
    func getCollectionsResponse(list: String, start: String, response: @escaping (Collections?) -> Void)
    func getSearchResponse(value: String, response: @escaping (StockSearch?) -> Void)
}

struct NetworkDataFetcher: DataFetcher {
    
    func getSearchResponse(value: String, response: @escaping (StockSearch?) -> Void) {
        
        let params = ["q": value]
        networking.requestWithToken(path: EndPoint.search.rawValue, params: params) { (data, error) in
            if let error = error {
                print("Error received requesting data: \(error.localizedDescription)")
                response(nil)
            }
            guard let data = data else { return }
            
            let decoded = self.decodeJSON(type: StockSearch.self, from: data)
            response(decoded)
        }
    }
    
    
    func getCollectionsResponse(list: String, start: String, response: @escaping (Collections?) -> Void) {
        let params = ["list": list, "start": start]
        networking.request(path: EndPoint.collections.rawValue, params: params) { (data, error) in
            if let error = error {
                print("Error received requesting data: \(error.localizedDescription)")
                response(nil)
            }
            guard let data = data else { return }
            
            let decoded = self.decodeJSON(type: Collections.self, from: data)
            
            response(decoded)
        }
    }
    
    
    let networking: Networking
    
    init(networking: Networking) {
        self.networking = networking
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
    
    private func decodeJSON<T: Decodable>(type: T.Type, from: Data?) -> T? {
        let decoder = JSONDecoder()
        guard let data = from, let response = try? decoder.decode(type.self, from: data) else { return nil }
        return response
    }
}
