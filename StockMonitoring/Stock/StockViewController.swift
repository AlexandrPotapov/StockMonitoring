//
//  StockViewController.swift
//  StockMonitoring
//
//  Created by Александр on 30.03.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol StockDisplayLogic: class
{
    func displayData(viewModel: Stock.Model.ViewModel.ViewModelData)
}

class StockViewController: UIViewController, StockDisplayLogic
{
    
    @IBOutlet weak var stockSearchBar: UISearchBar!
    @IBOutlet weak var stockSegmentedControl: UISegmentedControl!
    @IBOutlet weak var stockTableView: UITableView!
    
    var stockQuotes: [StockQuote] = [StockQuote(symbol: "AAPL", shortName: "Apple Inc.", postMarketPrice: 119.0, regularMarketChange: -0.10, regularMarketChangePercent: -0.01), StockQuote(symbol: "F", shortName: "Ford Motor Company", postMarketPrice: 12.46, regularMarketChange: 0.31, regularMarketChangePercent: 2.55)]
    var interactor: StockBusinessLogic?
    var router: (NSObjectProtocol & StockRoutingLogic & StockDataPassing)?
    
    private var stockViewModel = StockViewModel.init(cells: [])
    
    // MARK: Object lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)
    {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Setup
    
    private func setup()
    {
        let viewController = self
        let interactor = StockInteractor()
        let presenter = StockPresenter()
        let router = StockRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    // MARK: Routing
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let scene = segue.identifier {
            let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
            if let router = router, router.responds(to: selector) {
                router.perform(selector, with: segue)
            }
        }
    }
    
    // MARK: View lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        let stockCell = UINib(nibName: "StocksCell", bundle: nil)
        stockTableView.register(stockCell , forCellReuseIdentifier: StocksCell.reuseId)
        makeRequest()
    }
    
    // MARK: Do something
    
    //@IBOutlet weak var nameTextField: UITextField!
    
    func makeRequest()
    {
        interactor?.makeRequest(request: .getStocks)
    }
    
    func displayData(viewModel: Stock.Model.ViewModel.ViewModelData)
    {
        switch viewModel {
        
        case .displayStock:
            print(".displayStock ViewController")
        }
        //nameTextField.text = viewModel.name
    }
    
    @IBAction func StockSC(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {

        } else {

        }
        
    }
}

//MARK: Table Delegate/DataSource
extension StockViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stockViewModel.cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell  = tableView.dequeueReusableCell(withIdentifier: StocksCell.reuseId) as! StocksCell
//        cell.set(viewModel: <#T##StockCellViewModel#>)
        let cellViewModel = stockViewModel.cells[indexPath.row]
        cell.set(viewModel: cellViewModel)
        cell.symbol.text = stockQuotes[indexPath.row].symbol
        cell.nameCompany.text = stockQuotes[indexPath.row].shortName
        
        if let change = stockQuotes[indexPath.row].regularMarketChange {
            if change < 0 {
                cell.change.text = "-$" + String(abs(change))
                cell.change.textColor = .red
            } else {
                cell.change.text = "+$" + String(change)
                cell.change.textColor = UIColor(red: 0/255, green: 205/255, blue: 0/255, alpha: 1)
            }
        } else {
            cell.change.text = "-"
        }
        if let changePercent = stockQuotes[indexPath.row].regularMarketChange {
            cell.changePercent.text = "(" + String(abs(changePercent)) + "%" + ")"
            if changePercent < 0 {
                cell.changePercent.textColor = .red
            } else {
                cell.changePercent.textColor = UIColor(red: 0/255, green: 205/255, blue: 0/255, alpha: 1)
            }
        } else {
            cell.changePercent.text = "-"
        }
        return cell
        
        
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("select row")
        interactor?.makeRequest(request: .getStocks)
    }
    
    
}
