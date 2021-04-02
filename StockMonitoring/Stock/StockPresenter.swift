//
//  StockPresenter.swift
//  StockMonitoring
//
//  Created by Александр on 30.03.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol StockPresentationLogic
{
    func presentData(response: Stock.Model.Response.ResponseType)
}

class StockPresenter: StockPresentationLogic
{
  weak var viewController: StockDisplayLogic?
  
  // MARK: Do something
  
    func presentData(response: Stock.Model.Response.ResponseType)
  {
        switch response {
        
        case .presentStocks(stocksResponse: let stocks):
            
            let cells = stocks.first?.quotes.map { (stock) in
//                cellViewModel(from: stock)// получить из символов сток
            }
            
            let stockViewModel = StockViewModel.init(cells: [])
//            viewController?.displayData(viewModel: Stock.Model.ViewModel.ViewModelData.displayStock(stockViewModel: cells) )
        }
  }
    
    private func cellViewModel(from stock: StockQuote) -> StockViewModel.Cell {
        return StockViewModel.Cell.init(ticker: stock.symbol!,
                                        name: stock.shortName,
                                        price: String(stock.postMarketPrice!),
                                        change: String(stock.regularMarketChange!),
                                        changePercent: String(stock.regularMarketChangePercent!),
                                        favorite: false)
    }
}