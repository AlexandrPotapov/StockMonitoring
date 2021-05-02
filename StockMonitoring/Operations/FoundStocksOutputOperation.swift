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
    
    public init(_ foundStocks:[Stock]?, completion: @escaping ([Stock]?) -> ()) {
        _inputFoundStocks = foundStocks
        self.completion = completion
        super.init()
    }


    var foundStocks: [Stock]? {
        // Определяем, задан ли у операции inputImage
        // Если НЕТ, то анализируем dependencies,
        // которые "подтверждают" протокол ImagePass
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

    override public func main() {
        if isCancelled == true { print("cancelcancelcancelcancel FoundStocksOutputOperation cancelcancelcancelcancel")}
        if isCancelled { completion(nil)}
//        print("FoundStocksOutputOperation finish", foundStocks)
        completion(foundStocks)
    }
}

