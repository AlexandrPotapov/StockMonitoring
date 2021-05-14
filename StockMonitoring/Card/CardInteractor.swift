//
//  CardInteractor.swift
//  StockMonitoring
//
//  Created by Александр on 18.04.2021.

import UIKit



protocol CardInteractorProtocol: class {
    var isFavourite: Bool { get set }
    func provideCard()
    func setFavouriteStatus()
}

protocol CardInteractorOutputProtocol: class {
    func receiveCard(cardData: CardData)
}

class CardInteractor {

weak var presentor: CardInteractorOutputProtocol!
private var stock: Stock


  var isFavourite: Bool {
      get {
        return stock.isFavourite
      } set {
        stock.isFavourite = newValue
        if stock.isFavourite {
          FavouriteStocksCoreDataStore.instance.createStock(stockToCreate: stock) { _ in }
        } else {
          FavouriteStocksCoreDataStore.instance.deleteStock(ticker: stock.ticker) { _ in }

        }
      }
  }

  init(presentor: CardInteractorOutputProtocol, stock: Stock) {
      self.presentor = presentor
      self.stock = stock
  }
}

extension CardInteractor: CardInteractorProtocol {
  func provideCard() {
    let cardData = CardData(ticker: stock.ticker,
                            nameCompany: stock.nameCompany,
                            price: stock.price,
                            priceChange: stock.change,
                            priceChangePercent: stock.changePercent)
    presentor.receiveCard(cardData: cardData)
  }
  
  func setFavouriteStatus() {
    isFavourite.toggle()
  }

}
