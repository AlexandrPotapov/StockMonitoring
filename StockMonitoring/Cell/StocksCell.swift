//
//  StocksCell.swift
//  StockMonitoring
//
//  Created by Александр on 29.03.2021.
//

import Foundation
import UIKit

protocol StockCellViewModel {
    var ticker: String { get }
    var name: String? { get }
    var price: String? { get }
    var change: String? { get }
    var changePercent: String? { get }
    var favorite: Bool { get }
}
class StocksCell: UITableViewCell {
        
    @IBOutlet weak var symbol: UILabel!
    @IBOutlet weak var nameCompany: UILabel!
    @IBOutlet weak var priceStock: UILabel!
    @IBOutlet weak var change: UILabel!
    @IBOutlet weak var changePercent: UILabel!
    @IBOutlet weak var favoriteImage: UIView!
    
    static let reuseId = "StocksCell"
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func set(viewModel: StockCellViewModel) {
        symbol.text = viewModel.ticker
        nameCompany.text = viewModel.name
        priceStock.text = viewModel.price
        change.text = viewModel.change
        changePercent.text = viewModel.changePercent
        (favoriteImage as! FavoriteView).isFavorite = viewModel.favorite
    }
}
