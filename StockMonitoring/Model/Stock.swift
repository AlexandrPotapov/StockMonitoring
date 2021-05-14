//
//  Stock.swift
//  StockMonitoring
//
//  Created by Александр on 27.03.2021.


import Foundation

struct Stock {
    var ticker: String = ""
    var nameCompany: String?
    var price: Double?
    var change: Double?
    var changePercent: Double?
    var isFavourite: Bool = false
}

//struct StockViewModel {
//    struct Cell: StockCellViewModel {
//        var ticker: String?
//        var name: String?
//        var price: Double?
//        var change: Double?
//        var changePercent: Double?
//        var isFavorite: Bool?
//    }
//    
//    let cells: [Cell]
//}
