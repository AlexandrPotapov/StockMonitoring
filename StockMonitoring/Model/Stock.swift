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

