//
//  CardConfigurator.swift
//  StockMonitoring
//
//  Created by Александр on 13.05.2021.
//

import Foundation

protocol CardConfiguratorProtocol: class {
  func configure(with view: CardViewController, and stock: Stock, indexPath: IndexPath, delegate: CardModuleDelegate)
}

class CardConfigurator: CardConfiguratorProtocol {
    func configure(with view: CardViewController, and stock: Stock,  indexPath: IndexPath, delegate: CardModuleDelegate) {
      let presenter = CardPresenter(view: view, stockIndexPath: indexPath)
      let interactor = CardInteractor(presentor: presenter, stock: stock)
      let router = CardRouter(viewController: view, presenter: presenter, delegate: delegate)
      view.presenter = presenter
        presenter.interactor = interactor
      presenter.router = router

    }
}

