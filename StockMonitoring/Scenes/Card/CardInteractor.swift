//
//  CardInteractor.swift
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

protocol CardBusinessLogic
{
    func getStock(request: Card.GetStock.Request)
    func stockIsFavouriteChange(request: Card.StockIsFavouriteChange.Request)
}

protocol CardDataStore
{
    var stock: Stock! { get set }
    var stocks: [Stock] { get set }
    var favouriteStocksCoreDataStore: FavouriteStocksCoreDataStore! { get set }
    var stockIsDelete: Bool { get }
    var stockIsUpdate: Bool { get }
    var selectedRow: Int! {get set}
}

class CardInteractor: CardBusinessLogic, CardDataStore
{
    var favouriteStocksCoreDataStore: FavouriteStocksCoreDataStore!
    
    var selectedRow: Int!
    var stockIsDelete = false
    var stockIsUpdate = false
    var stock: Stock!
    var stocks = [Stock]()
    
    
    var presenter: CardPresentationLogic?
    
    func getStock(request: Card.GetStock.Request )
    {
        let response = Card.GetStock.Response(stock: stock)
        presenter?.Stock(response: response)
    }
    
    func stockIsFavouriteChange(request: Card.StockIsFavouriteChange.Request) {
        stockIsUpdate = true
        if stock.isFavourite {
            self.stock.isFavourite = false
            let response = Card.GetStock.Response(stock: self.stock)
            self.presenter?.Stock(response: response)
            favouriteStocksCoreDataStore.deleteStock(ticker: stock.ticker) { (stock: () throws -> Stock?) in
                self.stockIsDelete = true
            }
            
        } else {
            favouriteStocksCoreDataStore.createStock(stockToCreate: stock) { (stock: () throws -> Stock?) in
              guard let stock = try? stock() else { return }
                self.stocks.append(stock)
                self.stock.isFavourite = true
                let response = Card.GetStock.Response(stock: self.stock)
                self.presenter?.Stock(response: response)
                self.stockIsDelete = false
            }
        }
    }
}
