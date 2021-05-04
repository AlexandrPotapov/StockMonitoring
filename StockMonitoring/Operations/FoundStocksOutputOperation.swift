//
//  FoundStocksOutputOperation.swift
//  StockMonitoring
//
//  Created by Александр on 30.04.2021.
//

import Foundation

class FoundStocksOutputOperation: AsyncOperation {
    private let _inputFoundStocks: [Stock]?
    private let completion: ([Stock]?) -> ()
    
    var foundStocks: [Stock]? {
        var stocks: [Stock]?
        if let inputFoundStocks = _inputFoundStocks {
            stocks = inputFoundStocks
        } else if let dataProvider = dependencies
            .filter({ $0 is FoundStocksPass })
            .first as? FoundStocksPass {
            stocks = dataProvider.foundStocks
        }
        return stocks
    }
    
    public init(_ foundStocks:[Stock]?, completion: @escaping ([Stock]?) -> ()) {
        _inputFoundStocks = foundStocks
        self.completion = completion
        super.init()
    }

    override public func main() {
        if isCancelled { completion(nil)}
        completion(foundStocks)
    }
}

