//
//  StocksCell.swift
//  StockMonitoring
//
//  Created by Александр on 29.03.2021.
//

import Foundation
import UIKit

protocol StockCellViewModel {
    var ticker: String? { get }
    var name: String? { get }
    var price: Double? { get }
    var change: Double? { get }
    var changePercent: Double? { get }
    var isFavorite: Bool? { get }
}
class StocksCell: UITableViewCell {
    
    @IBOutlet weak var symbol: UILabel!
    @IBOutlet weak var nameCompany: UILabel!
    @IBOutlet weak var priceStock: UILabel!
    @IBOutlet weak var change: UILabel!
    @IBOutlet weak var changePercent: UILabel!
    @IBOutlet weak var favouriteImage: UIImageView!
    @IBOutlet weak var subView: UIView!
    @IBOutlet weak var tickerView: UIView!
    @IBOutlet weak var stockLabel: UILabel!
    
    static let reuseId = "StocksCell"
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func set(viewModel: StockCellViewModel) {
        var price = "-"
        var name: String!
        if var _price = viewModel.price {
            _price = Double(round(100*_price)/100)
            
            price = "$" + String(_price)
        }
        if var change = viewModel.change {
            change = Double(round(100*change)/100)
            if change < 0 {
                self.change.text = "-$" + String(abs(change))
                self.change.textColor = UIColor(red: 178/255, green: 36/255, blue: 36/255, alpha: 1)
            } else {
                self.change.text = "+$" + String(change)
                self.change.textColor = UIColor(red: 36/255, green: 178/255, blue: 93/255, alpha: 1)
            }
        } else {
            self.change.text = "-"
        }
        if var changePercent = viewModel.changePercent {
            changePercent = Double(round(100*changePercent)/100)
            self.changePercent.text = "(" + String(abs(changePercent)) + "%" + ")"
            if changePercent < 0 {
                self.changePercent.textColor = UIColor(red: 178/255, green: 36/255, blue: 36/255, alpha: 1)
            } else {
                self.changePercent.textColor = UIColor(red: 36/255, green: 178/255, blue: 93/255, alpha: 1)
            }
        } else {
            self.changePercent.text = "-"
        }
        
        if let nameCompany = viewModel.name {
            name = nameCompany
        }
        
        symbol.text = viewModel.ticker
        nameCompany.text = viewModel.name
        stockLabel.text = String(name[name.startIndex])
        priceStock.text = price
        if viewModel.isFavorite == false {
            favouriteImage.image = UIImage(named: "STAR2")
        } else {
            favouriteImage.image = UIImage(named: "Star")
        }
    }
}
