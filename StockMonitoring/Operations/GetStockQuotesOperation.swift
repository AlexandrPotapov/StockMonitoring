//
//  GetStockQuotesOperation.swift
//  StockMonitoring
//
//  Created by Александр on 30.04.2021.
//

import Foundation

protocol FoundStocksPass {
    var foundStocks: [Stock]? { get }

}
class GetStockQuotesOperation: AsyncOperation {
    var outputFoundStocks: [Stock]?
    private let _inputSymbols: String?
    
    init(_ symbols: String?) {
        _inputSymbols = symbols
        super.init()
    }

    var inputSymbols: String? {
        // Определяем, задан ли у операции inputImage
        // Если НЕТ, то анализируем dependencies,
        // которые "подтверждают" протокол ImagePass
        var symbols: String?
        if let inputSymbols = _inputSymbols {
            symbols = inputSymbols
        } else if let dataProvider = dependencies
            .filter({ $0 is FoundSymbolsString })
            .first as? FoundSymbolsString {
            symbols = dataProvider.foundSymbolsString
        }
        return symbols
    }

    override func main() {
        if isCancelled { return }
        NetworkDataFetcher(networking: NetworkService()).getQuoteResponse(value: inputSymbols!) { [ weak self ](stocks) in
            guard let stocks = stocks else { return }
            var foundStocks = [Stock]()
            for stock in stocks {
                foundStocks.append(Stock(ticker: stock.symbol!, nameCompany: stock.shortName, price: stock.regularMarketPrice, change: stock.regularMarketChange, changePercent: stock.regularMarketChangePercent, isFavourite: false))
            }
            if self?.isCancelled == true { return }
            self?.outputFoundStocks = foundStocks
//            print("self?.outputFoundStocks", self?.outputFoundStocks)
            self?.state = .finished


        }

    }
}

extension GetStockQuotesOperation: FoundStocksPass {
    var foundStocks: [Stock]? {
        return outputFoundStocks
    }
    
    
}
