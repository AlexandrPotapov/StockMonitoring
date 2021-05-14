//
//  StockPresenter.swift
//  StockMonitoring
//
//  Created by Александр on 30.03.2021.


import Foundation


protocol StockListPresenterProtocol: class {
  
  
  var stocks: [Stock] { get }
  var favouriteStocks: [Stock] { get set }
  var dowloadedStocks: [Stock] { get set }
  var favouriteStocksCoreDataStore: FavouriteStocksCoreDataStore! { get }
  var stocksCount: Int? { get }

  func stock(atIndex indexPath: IndexPath) -> Stock?
  func showCard(for indexPath: IndexPath)
  func changeCegment(to index: Int)
  func updatedStockFavouriteStatus(isFavourite: Bool, indexPath: IndexPath)
  func getStocks()
  func getFavouriteStocks()

  func viewDidLoad()
func viewWillAppear()

  
}

class StockListPresenter {
  
  var favouriteStocksCoreDataStore: FavouriteStocksCoreDataStore!
  var stocks = [Stock]()
  var favouriteStocks = [Stock]()
  var dowloadedStocks = [Stock]()
  var stocksCount: Int? = 0



  weak var view: StockListViewProtocol!
  var interactor: StockListInteractorProtocol!
  var router: StockListRouterProtocol!
  
  
  required init(view: StockListViewProtocol) {
      self.view = view
  }

//        private func cellViewModel(from stock: Stock) -> StockViewModel.Cell {
//        return StockViewModel.Cell.init(ticker: stock.ticker,
//                                        name: stock.nameCompany,
//                                        price: stock.price,
//                                        change: stock.change,
//                                        changePercent: stock.changePercent,
//                                        isFavorite: stock.isFavourite)
//    }
}


extension StockListPresenter: StockListPresenterProtocol {
  func stock(atIndex indexPath: IndexPath) -> Stock? {
    if stocks.indices.contains(indexPath.row) {
        return stocks[indexPath.row]
    } else {
        return nil
    }
  }
  
  func showCard(for indexPath: IndexPath) {
      if stocks.indices.contains(indexPath.row) {
          let stock = stocks[indexPath.row]
        router.openCardViewController(with: stock, indexPath: indexPath)
      }
  }
  
  func changeCegment(to index: Int) {
    if index == 1 {
      getFavouriteStocks()
    } else {
      getStocks()
    }
  }
  
  func updatedStockFavouriteStatus(isFavourite: Bool, indexPath: IndexPath) {
    stocks[indexPath.row].isFavourite = isFavourite
    if isFavourite == false {
      if !favouriteStocks.isEmpty {
        for (i, favouriteStock) in favouriteStocks.enumerated() {
          print(favouriteStock)
          for stock in stocks {
            if favouriteStock.ticker == stock.ticker {
              favouriteStocks[i].isFavourite = false
            }
          }
        }
    }
    }
    view.reloadData()
  }
  
  func getStocks() {
    if dowloadedStocks.isEmpty {
      interactor.getStocks()
    } else {
      
      if !favouriteStocks.isEmpty {
        for favouriteStock in favouriteStocks {
          print(favouriteStock)
          for (i, stock) in dowloadedStocks.enumerated() {
            if favouriteStock.ticker == stock.ticker {
              dowloadedStocks[i].isFavourite = favouriteStock.isFavourite
            }
          }
        }
    }
      stocksCount = dowloadedStocks.count
      stocks = dowloadedStocks
      view.reloadData()
    }
  }
  
  func getFavouriteStocks() {
    interactor.getFavouriteStocks()
  }
  
  func viewDidLoad() {
    interactor.getFavouriteStocks()
    interactor.getStocks()
  }
  func viewWillAppear() {
    
  }
}

extension StockListPresenter: StockListInteractorOutputProtocol {
  func stocksDidReceive(_ stocks: [Stock]) {
    dowloadedStocks = stocks
    stocksCount = stocks.count
    
    if !favouriteStocks.isEmpty {
      for favouriteStock in favouriteStocks {
        for (i, dowloadedStock) in dowloadedStocks.enumerated() {
          if favouriteStock.ticker == dowloadedStock.ticker {
            dowloadedStocks[i].isFavourite = true
          }
        }
      }
    }
    print(stocksCount)
    self.stocks = dowloadedStocks
    view.reloadData()
  }
  func favouriteStocksDidReceive(_ stocks: [Stock]) {
    favouriteStocks = stocks
    stocksCount = stocks.count
    self.stocks = favouriteStocks
    view.reloadData()
  }
}
