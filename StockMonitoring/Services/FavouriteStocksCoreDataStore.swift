//
//  FavouriteStocksCoreDataStore.swift
//  StockMonitoring
//
//  Created by Александр on 20.04.2021.
//

import Foundation
import CoreData

class FavouriteStocksCoreDataStore: StocksStoreProtocol {
    
    static let instance = FavouriteStocksCoreDataStore()
    
    
    // MARK: - Managed object contexts
    
    static private var _mainManagedObjectContext: NSManagedObjectContext?
    static var mainManagedObjectContext: NSManagedObjectContext
    {
        get
        {
            if _mainManagedObjectContext == nil {
                _mainManagedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
            }
            return _mainManagedObjectContext!
        }
        set
        {
            _mainManagedObjectContext = newValue
        }
    }
    
    // MARK: - Object lifecycle
    
    init()
    {
        guard let modelURL = Bundle.main.url(forResource: "StockMonitoring", withExtension: "momd") else {
            fatalError("Error loading model from bundle")
        }
        
        guard let mom = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Error initializing mom from: \(modelURL)")
        }
        
        let psc = NSPersistentStoreCoordinator(managedObjectModel: mom)
        FavouriteStocksCoreDataStore.mainManagedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        FavouriteStocksCoreDataStore.mainManagedObjectContext.persistentStoreCoordinator = psc
        
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let docURL = urls[urls.endIndex-1]

        let storeURL = docURL.appendingPathComponent("StockMonitoring.sqlite")
        do {
            try psc.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: nil)
        } catch {
            fatalError("Error migrating store: \(error)")
        }
    }
    
    deinit
    {
        do {
            try FavouriteStocksCoreDataStore.mainManagedObjectContext.save()
        } catch {
            fatalError("Error deinitializing main managed object context")
        }
    }
    
    // MARK: - CRUD operations - Optional error
    
    func fetchStocks(completionHandler: @escaping (() throws -> [Stock]) -> Void)
    {
        do {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FavouriteStock")
            let results = try FavouriteStocksCoreDataStore.mainManagedObjectContext.fetch(fetchRequest) as! [FavouriteStock]
            var stocks = [Stock]()
            for favouriteStock in results {
                stocks.append(Stock(ticker: favouriteStock.ticker!, nameCompany: favouriteStock.nameCompany, price: favouriteStock.price as? Double, change: favouriteStock.change as? Double, changePercent: favouriteStock.changePercent as? Double, isFavourite: (favouriteStock.isFavourite as? Bool)!))
            }
            DispatchQueue.main.async {
                completionHandler { return stocks}
            }
        } catch {
            DispatchQueue.main.async {
                completionHandler { throw StockQuotesStoreError.CannotFetch("Cannot fetch stocks") }
            }
        }
    }
    
    func fetchStock(ticker: String, completionHandler: @escaping (() throws -> Stock?) -> Void)
    {
        do {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FavouriteStock")
            fetchRequest.predicate = NSPredicate(format: "ticker == %@", ticker)
            let results = try FavouriteStocksCoreDataStore.mainManagedObjectContext.fetch(fetchRequest) as! [FavouriteStock]
            if let favouriteStock = results.first {
                let stock = Stock(ticker: favouriteStock.ticker!, nameCompany: favouriteStock.nameCompany, price: favouriteStock.price as? Double, change: favouriteStock.change as? Double, changePercent: favouriteStock.changePercent as? Double, isFavourite: (favouriteStock.isFavourite as? Bool)!)
                DispatchQueue.main.async {
                    completionHandler { return stock }
                }
            } else {
                DispatchQueue.main.async {
                    completionHandler { throw StockQuotesStoreError.CannotFetch("Cannot fetch stock with id \(ticker)") }
                }
            }
        } catch {
            DispatchQueue.main.async {
                completionHandler { throw StockQuotesStoreError.CannotFetch("Cannot fetch stock with id \(ticker)") }
            }
        }
    }
    
    func createStock(stockToCreate: Stock, completionHandler: @escaping (() throws -> Stock?) -> Void)
    {
        do {
            let favouriteStock = NSEntityDescription.insertNewObject(forEntityName: "FavouriteStock", into: FavouriteStocksCoreDataStore.mainManagedObjectContext) as! FavouriteStock
            var stock = stockToCreate
            stock.isFavourite = true
            
            favouriteStock.ticker = stock.ticker
            favouriteStock.nameCompany = stock.nameCompany
            favouriteStock.price = stock.price as NSNumber?
            favouriteStock.change = stock.change as NSNumber?
            favouriteStock.changePercent = stock.changePercent as NSNumber?
            favouriteStock.isFavourite = stock.isFavourite as NSNumber?
            try FavouriteStocksCoreDataStore.mainManagedObjectContext.save()
            completionHandler {return stock }
        } catch {
            DispatchQueue.main.async {
                completionHandler { throw StockQuotesStoreError.CannotCreate("Cannot create stock with ticker \(String(describing: stockToCreate.ticker))") }
            }
        }
    }
    
    func updateStock(stockToUpdate: Stock, completionHandler: @escaping (() throws -> Stock?) -> Void)
    {
        do {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FavouriteStock")
            fetchRequest.predicate = NSPredicate(format: "ticker == %@", stockToUpdate.ticker)
            let results = try FavouriteStocksCoreDataStore.mainManagedObjectContext.fetch(fetchRequest) as! [FavouriteStock]
            if let favouriteStock = results.first {
                favouriteStock.price = stockToUpdate.price as NSNumber?
                favouriteStock.change = stockToUpdate.change as NSNumber?
                favouriteStock.changePercent = stockToUpdate.changePercent as NSNumber?
                do {
                  try FavouriteStocksCoreDataStore.mainManagedObjectContext.save()
                  DispatchQueue.main.async {
                    completionHandler { return stockToUpdate }
                  }
                } catch {
                  DispatchQueue.main.async {
                    completionHandler { throw StockQuotesStoreError.CannotUpdate("Cannot fetch stock with ticker  to update") }
                  }
                }
              } else {
                DispatchQueue.main.async {
                    completionHandler { throw StockQuotesStoreError.CannotUpdate("Cannot fetch stock with ticker  to update") }
                }
            }
        } catch {
            DispatchQueue.main.async {
                completionHandler { throw StockQuotesStoreError.CannotUpdate("Cannot fetch stock with ticker  to update") }
            }
        }
    }

    
    
    func deleteStock(ticker: String, completionHandler: @escaping (() throws -> Stock?) -> Void)
    {
        do {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FavouriteStock")
            fetchRequest.predicate = NSPredicate(format: "ticker == %@", ticker)
            let results = try FavouriteStocksCoreDataStore.mainManagedObjectContext.fetch(fetchRequest) as! [FavouriteStock]
            if let favouriteStock = results.first {
                FavouriteStocksCoreDataStore.mainManagedObjectContext.delete(favouriteStock)
                try FavouriteStocksCoreDataStore.mainManagedObjectContext.save()
                var stock = Stock()
                stock.ticker = favouriteStock.ticker ?? ""
                stock.nameCompany = favouriteStock.nameCompany
                stock.price = favouriteStock.price as? Double
                stock.change = favouriteStock.change as? Double
                stock.changePercent = favouriteStock.changePercent as? Double
                stock.isFavourite = favouriteStock.isFavourite as? Bool ?? false
                DispatchQueue.main.async {
                    completionHandler { stock }
                }
            } else {
                DispatchQueue.main.async {
                    completionHandler { throw StockQuotesStoreError.CannotDelete("Cannot fetch stock with ticker \(ticker) to delete") }
                }
            }
        } catch {
            DispatchQueue.main.async {
                completionHandler { throw StockQuotesStoreError.CannotDelete("Cannot fetch stock with ticker \(ticker) to delete") }
            }
        }
    }
}



// MARK: - Orders store CRUD operation results

typealias StockQuotesStoreFetchStockQuotesCompletionHandler = (StockQuotesStoreResult<[StockQuote]>) -> Void
typealias StockQuotesStoreFetchStockQuoteCompletionHandler = (StockQuotesStoreResult<StockQuote>) -> Void
typealias StockQuotesStoreCreateStockQuoteCompletionHandler = (StockQuotesStoreResult<StockQuote>) -> Void
typealias StockQuotesStoreUpdateStockQuoteCompletionHandler = (StockQuotesStoreResult<StockQuote>) -> Void
typealias StockQuotesStoreDeleteStockQuoteCompletionHandler = (StockQuotesStoreResult<StockQuote>) -> Void

enum StockQuotesStoreResult<U>
{
    case Success(result: U)
    case Failure(error: StockQuotesStoreError)
}

// MARK: - Orders store CRUD operation errors

enum StockQuotesStoreError: Equatable, Error
{
    case CannotFetch(String)
    case CannotCreate(String)
    case CannotDelete(String)
    case CannotUpdate(String)
}

func ==(lhs: StockQuotesStoreError, rhs: StockQuotesStoreError) -> Bool
{
    switch (lhs, rhs) {
    case (.CannotFetch(let a), .CannotFetch(let b)) where a == b: return true
    case (.CannotCreate(let a), .CannotCreate(let b)) where a == b: return true
    case (.CannotDelete(let a), .CannotDelete(let b)) where a == b: return true
    default: return false
    }
}


protocol StocksStoreProtocol
{
    
    func fetchStocks(completionHandler: @escaping (() throws -> [Stock]) -> Void)
    func fetchStock(ticker: String, completionHandler: @escaping (() throws -> Stock?) -> Void)
    func createStock(stockToCreate: Stock, completionHandler: @escaping (() throws -> Stock?) -> Void)
    func updateStock(stockToUpdate: Stock, completionHandler: @escaping (() throws -> Stock?) -> Void)
    func deleteStock(ticker: String, completionHandler: @escaping (() throws -> Stock?) -> Void)
}
