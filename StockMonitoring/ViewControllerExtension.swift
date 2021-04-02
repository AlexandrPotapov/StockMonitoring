//
//  ViewControllerExtension.swift
//  StockMonitoring
//
//  Created by Александр on 29.03.2021.
//

import Foundation
import UIKit

//extension ViewController: UITableViewDelegate, UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return stockQuotes.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        
//        let cell  = tableView.dequeueReusableCell(withIdentifier: "StocksCell") as! StocksCell
//        
//        cell.symbol.text = stockQuotes[indexPath.row].symbol
//        cell.nameCompany.text = stockQuotes[indexPath.row].shortName
//        
//        if let change = stockQuotes[indexPath.row].regularMarketChange {
//            if change < 0 {
//                cell.change.text = "-$" + String(change)
//                cell.change.textColor = .red
//            } else {
//                cell.change.text = "+$" + String(change)
//                cell.change.textColor = .green
//            }
//        } else {
//            cell.change.text = "-"
//        }
//        if let changePercent = stockQuotes[indexPath.row].regularMarketChange {
//            cell.changePercent.text = "(" + String(changePercent) + "%" + ")"
//            if changePercent < 0 {
//                cell.changePercent.textColor = .red
//            } else {
//                cell.changePercent.textColor = .green
//            }
//        } else {
//            cell.changePercent.text = "-"
//        }
//        return cell
//        
//        
//    }
//    
//    
//}
