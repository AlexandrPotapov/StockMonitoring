//
//  SearchOperation.swift
//  StockMonitoring
//
//  Created by Александр on 30.04.2021.
//

import Foundation
import UIKit

protocol FoundSymbolsString {
    var foundSymbolsString: String? { get  }
}

class SearchOperation: AsyncOperation {
    private var request: String?
    fileprivate var stringRequest: String?
    
    public init(request: String?) {
        self.request = request
        super.init()
    }
    override public func main() {
        if self.isCancelled { return }
        guard let requestString = request else { return }
        NetworkDataFetcher(networking: NetworkService()).getSearchResponse(value: requestString) { [ weak self ] (searchResult) in
            guard let searchResult = searchResult else { return }
            var array = [String]()
            for value in searchResult.result {
                if value.type == "Common Stock" && !value.symbol.contains(".") {
                    array.append(value.symbol)
                        }
                    }
            if self?.isCancelled == true { return }
            self?.stringRequest = array.joined(separator:",")
            self?.state = .finished
        }
    }
}

extension SearchOperation: FoundSymbolsString {
    var foundSymbolsString: String? { return stringRequest }
}
