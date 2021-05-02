//
//  GetStockOperation.swift
//  StockMonitoring
//
//  Created by Александр on 01.05.2021.
//

import Foundation

class GetStockOperation: AsyncOperation {
    private var foundStocks: [Stock]?
    
    var listParam = "most_actives"
    var startParam = 0
    
    
    private let completion: ([Stock]?) -> ()
    
    public init(_ listParam: String, _ startParam: Int, completion: @escaping ([Stock]?) -> ()) {
        self.listParam = listParam
        self.startParam = startParam
        self.completion = completion
        super.init()
    }
    
    public init(_ completion: @escaping ([Stock]?) -> ()) {
        self.completion = completion
        super.init()
    }


    override public func main() {
        if isCancelled { completion(nil)}
        NetworkDataFetcher(networking: NetworkService()).getCollectionsResponse(list: listParam, start: "\(startParam)") { (stockCollections) in
            guard let stockCollections = stockCollections else { return }
            var foundStocks = [Stock]()
            for stock in stockCollections.quotes {
                foundStocks.append(Stock(ticker: stock.symbol!, nameCompany: stock.shortName!, price: stock.regularMarketPrice!, change: stock.regularMarketChange!, changePercent: stock.regularMarketChangePercent!, isFavourite: false))

            }
            if self.isCancelled { return }
            self.foundStocks = foundStocks
            self.completion(foundStocks)
            self.state = .finished
        }
//        print("FoundStocksOutputOperation finish", foundStocks)

    }
}
