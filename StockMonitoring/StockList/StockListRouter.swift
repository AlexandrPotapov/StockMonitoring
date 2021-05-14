//
//  StockRouter.swift
//  StockMonitoring
//
//  Created by Александр on 30.03.2021.

import Foundation

protocol StockListRouterProtocol {
  func openCardViewController(with stock: Stock, indexPath: IndexPath)

}


class StockListRouter: NSObject {
  
  weak var viewController: StockListViewController!
    
  init(viewController: StockListViewController) {
      self.viewController = viewController
  }
}


extension StockListRouter: StockListRouterProtocol {
  func openCardViewController(with stock: Stock, indexPath: IndexPath) {
    viewController.performSegue(
        withIdentifier: viewController.selfToCardSegueName,
      sender: (indexPath, stock)
    )
  }
}
