//
//  SearchProvider.swift
//  StockMonitoring
//
//  Created by Александр on 30.04.2021.
//

import Foundation

class SearchProvider {
    
    private var operationQueue = OperationQueue ()
    let request: String
    
    init(request: String,completion: @escaping ([Stock]?) -> ()) {
        self.request = request
        
        
        // Создаем операции
        let search = SearchOperation(request: request)
        let getStockQuotes = GetStockQuotesOperation(nil)
        let output = FoundStocksOutputOperation(nil, completion: completion)
        
        let operations = [search, getStockQuotes, output]
        
        // Добавляем dependencies
        getStockQuotes.addDependency(search)
        output.addDependency(getStockQuotes)
        print("qweqwe222211111222")
        operationQueue.addOperations(operations, waitUntilFinished: false)
    }
    
    func cancel() {
        operationQueue.cancelAllOperations()
    }
    
  }

extension SearchProvider: Hashable {
    var hashValue: Int {
        return (request).hashValue
    }
}

func ==(lhs: SearchProvider, rhs: SearchProvider) -> Bool {
    return lhs.request == rhs.request
}
