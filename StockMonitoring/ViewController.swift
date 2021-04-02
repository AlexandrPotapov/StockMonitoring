//
//  ViewController.swift
//  StockMonitoring
//
//  Created by Александр on 26.03.2021.
//

import UIKit

//class ViewController: UIViewController {
//    
//    @IBOutlet weak var stockSearchBar: UISearchBar!
//    @IBOutlet weak var stockSegmentedControl: UISegmentedControl!
//    var stockQuotes = [StockQuote]()
//    
//    private var fetcher: DataFetcher = NetworkDataFetcher(networking: NetworkService())
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        func sum(a: Int, b: Int) -> Int {
//        return a + b
//        }
//        view.backgroundColor = #colorLiteral(red: 0.5671284795, green: 0.7945078611, blue: 0.9987251163, alpha: 1)
//        fetcher.getQuoteResponse(value: "FLT.V,F") { (quoteResponse) in
//            guard let quoteResponse = quoteResponse else { return }
//            for quote in quoteResponse {
//                print(quote.shortName)
//            }
//        }
//        var value = ""
//        fetcher.getMostWatchedResponse { (mostWatchedTickers) in
//            guard let mostWatchedTickers = mostWatchedTickers?.first else { return }
//            print(222)
//            mostWatchedTickers.quotes.map({ (ticker) in
//                print(ticker)
//            })
//            let array30 = mostWatchedTickers.quotes?.prefix(30)
//            value = array30?.joined(separator: ",") ?? "убрать опционал"
//            print(value)
//            print(value)
//            print(mostWatchedTickers.count)
//    }
//        
//        fetcher.getNewsResponse(symbol: "AAPL") { (newsResponse) in
//            guard let newsResponse = newsResponse else { return }
//            newsResponse.item.map({ (news) in
//                print(news.description)
//            })
//        }
//        fetcher.getHistoryResponse(symbol: "AAPL", interval: "5m", diffAndSplits: "true") { (quoteHistory) in
//                        guard let quoteHistory = quoteHistory else { return }
//            quoteHistory.items.map({ (history) in
//                print(history.value.high)
//                        })
//        }
//    }
//    @IBAction func StockSC(_ sender: UISegmentedControl) {
//        if sender.selectedSegmentIndex == 0 {
//
//        } else {
//
//        }
//
//    }
//}

