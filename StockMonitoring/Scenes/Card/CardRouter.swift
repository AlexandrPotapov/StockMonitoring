//
//  CardRouter.swift
//  StockMonitoring
//
//  Created by Александр on 18.04.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

@objc protocol CardRoutingLogic
{
  func routeToStock(segue: UIStoryboardSegue?)
}

protocol CardDataPassing
{
  var dataStore: CardDataStore? { get }
}

class CardRouter: NSObject, CardRoutingLogic, CardDataPassing
{
  weak var viewController: CardViewController?
  var dataStore: CardDataStore?
  
  // MARK: Routing
  
  func routeToStock(segue: UIStoryboardSegue?)
  {
    let destinationVC = viewController?.navigationController?.viewControllers.first as! StockViewController
      var destinationDS = destinationVC.router!.dataStore!
      passDataToStock(source: dataStore!, destination: &destinationDS)
      navigateToStock(source: viewController!, destination: destinationVC)
  }

//   MARK: Navigation
  
  func navigateToStock(source: CardViewController, destination: StockViewController)
  {
    source.navigationController?.popViewController(animated: true)
  }
  
//   MARK: Passing data
  
  func passDataToStock(source: CardDataStore, destination: inout StockDataStore)
  {
    guard source.stockIsUpdate else { return }
    if source.stockIsDelete {
        for (i, value) in destination.favouriteStocks.enumerated() {
            if value.ticker == source.stock.ticker {
                destination.favouriteStocks.remove(at: i)
            }
        }

    } else {
        destination.favouriteStocks.append(source.stock)

    }
  }
}
