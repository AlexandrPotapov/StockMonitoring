//
//  CardRouter.swift
//  StockMonitoring
//
//  Created by Александр on 18.04.2021.


import UIKit

protocol CardRouterProtocol {
  func backToStockListViewController()

}

protocol CardModuleDelegate: class {
    func updatedStockFavouriteStatus(isFavourite: Bool, indexPath: IndexPath)
}


class CardRouter: NSObject {
  
  weak var viewController: CardViewController!
  weak var presenter: CardPresenter!
  weak var delegate: CardModuleDelegate?
    
  init(viewController: CardViewController, presenter: CardPresenter, delegate: CardModuleDelegate?) {
      self.viewController = viewController
    self.presenter = presenter
    self.delegate = delegate
  }
}


extension CardRouter: CardRouterProtocol {
  func backToStockListViewController() {
    self.delegate?.updatedStockFavouriteStatus(isFavourite: presenter.isFavourite, indexPath: presenter.stockIndexPath)
    viewController.navigationController?.popViewController(animated: true)
  }
}
