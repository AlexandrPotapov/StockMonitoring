//
//  searchOperations.swift
//  StockMonitoring
//
//  Created by Александр on 29.04.2021.
//
//
//import Foundation
//import UIKit
//
//// This enum contains all the possible states a photo record can be in
//enum StockRecordState {
//  case new, downloaded, filtered, failed
//}
//
//class StockRecord {
//    let stock: Stock
//    let requestValue: String
//    var searchResult: [SearchResult]
//
//  
//  init(stock: Stock, requestValue: String) {
//    self.stock = stock
//    self.requestValue = requestValue
//  }
//}
//
//class PendingOperations {
//  lazy var searchesInProgress: [IndexPath: Operation] = [:]
//  lazy var searchQueue: OperationQueue = {
//    var queue = OperationQueue()
//    queue.name = "Search queue"
//    queue.maxConcurrentOperationCount = 1
//    return queue
//  }()
//  
//  lazy var getQuoteInProgress: [IndexPath: Operation] = [:]
//  lazy var getQuoteQueue: OperationQueue = {
//    var queue = OperationQueue()
//    queue.name = "Get Quotes queue"
//    queue.maxConcurrentOperationCount = 1
//    return queue
//  }()
//}
//
//class ImageDownloader: Operation {
//  //1
//  let stockRecord: StockRecord
//
//  
//  //2
//  init(_ photoRecord: StockRecord) {
//    self.stockRecord = photoRecord
//  }
//  
//  //3
//  override func main() {
//    //4
//    if isCancelled {
//      return
//    }
//
//    //5
//    NetworkDataFetcher(networking: NetworkService()).getSearchResponse(value: stockRecord.requestValue) { [ weak self ] (searchResult) in
//        if ((self?.isCancelled) != nil) {
//          return
//        }
//        guard let searchResult = searchResult else { return }
//        self?.stockRecord.searchResult = searchResult.result
//        var array = [String]()
//        for value in searchResult.result {
//            if value.type == "Common Stock" && !value.symbol.contains(".") {
//                array.append(value.symbol)
//                    }
//                }
//                    let stringRequest = array.joined(separator:",")
//                if stringRequest != "" {
//                    print(8888,stringRequest, 88888)
//        
//        
//    }
//    
//    //6
//
//    }
//    
//    //7
//  }
//}
