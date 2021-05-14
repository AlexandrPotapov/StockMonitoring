//
//  StockListConfigurator.swift
//  StockMonitoring
//
//  Created by Александр on 11.05.2021.
//

import Foundation

protocol StockListConfiguratorProtocol: class {
    func configure(with viewController: StockListViewController)
}

class StockListCofigurator: StockListConfiguratorProtocol {
    func configure(with viewController:StockListViewController) {
      let presenter = StockListPresenter(view: viewController)
        let interactor = StockListInteractor(presenter: presenter)
        let router = StockListRouter(viewController: viewController)
        
        viewController.presenter = presenter
        presenter.interactor = interactor
        presenter.router = router
    }
}

