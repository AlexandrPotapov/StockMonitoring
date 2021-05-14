//
//  StockInteractor.swift
//  StockMonitoring
//
//  Created by Александр on 30.03.2021.

import Foundation

protocol StockListInteractorProtocol: class {
  func getStocks()
  func getFavouriteStocks()
}

protocol StockListInteractorOutputProtocol: class {
  func stocksDidReceive(_ stocks: [Stock])
  func favouriteStocksDidReceive(_ stocks: [Stock])

}

class StockListInteractor {
  
  weak var presenter: StockListInteractorOutputProtocol!

  required init(presenter: StockListInteractorOutputProtocol) {
      self.presenter = presenter
  }
  
  
  
  var indexPath: Int!
  
  var favouriteStocksCoreDataStore: FavouriteStocksCoreDataStore!
  
  
  private var operationQueue = OperationQueue ()
  private var fetcher: DataFetcher = NetworkDataFetcher(networking: NetworkService())
    
  
}

extension StockListInteractor: StockListInteractorProtocol {

  
  func getStocks() {

      let operation = GetStocksOperation { (stocks) in // weak slef
        guard let stocks = stocks else { return }
          self.presenter.stocksDidReceive(stocks)
        }
    operationQueue.addOperation(operation)
  }
  
  func getFavouriteStocks() {
    operationQueue.cancelAllOperations()
    favouriteStocksCoreDataStore = FavouriteStocksCoreDataStore.instance
    favouriteStocksCoreDataStore.fetchStocks { (stocks: () throws -> [Stock]) in
      do {
        let favouriteStocks = try stocks()
        self.presenter.favouriteStocksDidReceive(favouriteStocks)
      } catch {}
    }
  }
    
  
}
