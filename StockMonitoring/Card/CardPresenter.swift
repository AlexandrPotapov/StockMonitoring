//
//  CardPresenter.swift
//  StockMonitoring
//
//  Created by Александр on 18.04.2021.


import UIKit
struct CardData {
    let ticker: String?
    let nameCompany: String?
    let price: Double?
    let priceChange: Double?
    let priceChangePercent: Double?
}

protocol CardPresenterProtocol: class {
    var isFavourite: Bool { get }
    var stockIndexPath: IndexPath { get }
    func showCard()
    func favouriteButtonPressed()
  func backToStockListViewController()
}


class CardPresenter {  
  
  weak var view: CardViewProtocol!
  var interactor: CardInteractorProtocol!
  var router: CardRouterProtocol!
  var stockIndexPath: IndexPath
  
  var isFavourite: Bool {
    return interactor.isFavourite
  }
  
  required init(view: CardViewProtocol, stockIndexPath: IndexPath) {
      self.view = view
    self.stockIndexPath = stockIndexPath
  }

    func getAttributedString(string: String, font: UIFont) -> NSMutableAttributedString {
        let paramString = [NSAttributedString.Key.font : font]
        return NSMutableAttributedString(string: string, attributes: paramString as [NSAttributedString.Key : Any])
    }
  
  func getTitle(with ticker: String,_ nameCompany: String) -> NSMutableAttributedString {
    let title = getAttributedString(string: ticker, font: UIFont(name: "Montserrat-Bold", size: 18)!)
    let shortName = getAttributedString(string: nameCompany, font: UIFont(name: "Montserrat-Bold", size: 12)!)
    title.append(NSAttributedString(string: "\n"))
    title.append(shortName)
    return title
  }
}

extension CardPresenter: CardPresenterProtocol {
  func favouriteButtonPressed() {
    interactor.setFavouriteStatus()
    view.setImageForFavoriteButton()
  }
  
  func showCard() {
    interactor.provideCard()

  }
  
  func backToStockListViewController() {
    router.backToStockListViewController()
  }
    
}

// MARK: - CardInteractorOutputProtocol
extension CardPresenter: CardInteractorOutputProtocol {
  func receiveCard(cardData: CardData) {
    view.setTitle(with: getTitle(with: cardData.ticker ?? "", cardData.nameCompany ?? ""))
    view.setPrice(with: String(cardData.price!))
    view.setPriceChange(with: String(cardData.priceChange!))
    view.setPricePercentChange(with: String(cardData.priceChangePercent!))
    view.setImageForFavoriteButton()
  }
  

}
