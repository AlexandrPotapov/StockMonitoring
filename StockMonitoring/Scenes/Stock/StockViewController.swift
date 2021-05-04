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
    func displayData(viewModel: StockModel.Model.ViewModel.ViewModelData)
}

class StockViewController: UIViewController, StockDisplayLogic, StocksSegmentedControlDelegate, TextFieldDidChange
{

    

    
    
    
    @IBOutlet weak var topPadding40: UIView!
    @IBOutlet weak var topPadding36: UIView!
    @IBOutlet weak var stackView: UIStackView!
    
    @IBOutlet weak var searchHeader: UIView!
    @IBOutlet weak var stockActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var stockSegmentedControl: StocksSegmentedControl! {
        didSet{
            stockSegmentedControl.setButtonTitles(buttonTitles: ["Stocks","Favourite"])
            stockSegmentedControl.selectorTextColor = UIColor(red: 2/255, green: 2/255, blue: 2/255, alpha: 1)
        }
    }
    @IBOutlet weak var stockTableView: UITableView!

    var interactor: StockBusinessLogic?
    var router: (NSObjectProtocol & StockRoutingLogic & StockDataPassing)?
    var stocksIsSelect = true
    var favouriteIsSelect = false
    var searchIsSelect = false
  var searchProviders = Set<SearchProvider>()
  
    private var pickedStocksSegment = true
    private var offSetNavBar = CGFloat(0.0)
    private var titleView = TitleView()
    private var lastContentOffset: CGFloat = 0
    private var stockViewModel = StockViewModel.init(cells: [])
    
    private var stockTablePresented = false
    private var favouriteTablePresented = false
    private var searchTablePresented = false
    
    
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
        stockActivityIndicator.startAnimating()
        stockActivityIndicator.isHidden = false
        stockTablePresented = true

        searchHeader.isHidden = true
        topPadding36.isHidden = true

        titleView.myTextField.customDelegate = self
        stockSegmentedControl.delegate = self
        
        let stockCell = UINib(nibName: "StocksCell", bundle: nil)
        stockTableView.register(stockCell , forCellReuseIdentifier: StocksCell.reuseId)
        setupTopBars()
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.didTapView))
        tapGestureRecognizer.numberOfTapsRequired = 1
        tapGestureRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGestureRecognizer)


    }


      override func viewWillAppear(_ animated: Bool) {
        for view : UIView in (navigationController?.navigationBar.subviews)! {
          view.clipsToBounds = false
        }
        if searchTablePresented == true {
            getSearch(request: "")
        }
        if searchIsSelect == false {
        if stockTablePresented == true {
            getStocks(requestNeedsCancel: false)
        } else if favouriteTablePresented == true {
            getFavouriteStocks()
        }
        }

        navigationController?.navigationBar.transform = .init(translationX: 0, y: -offSetNavBar)
        navigationItem.titleView?.layoutIfNeeded()
        self.navigationController?.isNavigationBarHidden = false

      }

    
    // MARK: Do something
        
    func getStocks(requestNeedsCancel: Bool) {
                
        favouriteIsSelect = false
        stocksIsSelect = true
        searchIsSelect = false
        interactor?.makeRequest(request: .getStocks(requestNeedsCancel: requestNeedsCancel) )
    }
    
    func getFavouriteStocks() {
        favouriteIsSelect = true
        stocksIsSelect = false
        searchIsSelect = false
        stockActivityIndicator.isHidden = true
        interactor?.makeRequest(request: .getFavouriteStocks)
    }
    
    func getSearch(request: String) {
        favouriteIsSelect = false
        stocksIsSelect = false
        searchIsSelect = true
        stockActivityIndicator.isHidden = false
        interactor?.makeRequest(request: .getSearch(request: request))
    }

    
    func displayData(viewModel: StockModel.Model.ViewModel.ViewModelData)
    {
        switch viewModel {
        
        case .displayStock(stockViewModel: let stockViewModel):
            self.stockViewModel = stockViewModel
            stockTableView.reloadData()
        case .hideActivityIndicator:
            stockActivityIndicator.isHidden = true
            stockTableView.reloadData()
        }
    }
 
// MARK: Delegates
    func change(to index: Int) {
        if index == 1 {
            getStocks(requestNeedsCancel: true)

            getFavouriteStocks()
            pickedStocksSegment = false
            
            stockTablePresented = false
            favouriteTablePresented = true
            searchTablePresented = false
        } else {
            pickedStocksSegment = true
            stockTablePresented = true
            favouriteTablePresented = false
            searchTablePresented = false
          
            stockActivityIndicator.isHidden = false
            getStocks(requestNeedsCancel: false)
        }
    }

    func textFieldDidChange(to value: String, isChange: Bool) {
        if isChange {
            if value != "" {
                stockSegmentedControl.isHidden = true
                topPadding40.isHidden = true
                searchHeader.isHidden = false
                topPadding36.isHidden = false
                getSearch(request: value)

                searchTablePresented = true
            }
        } else {
                        if value == "" {
                            searchTablePresented = false
                            getSearch(request: value)

                        stockSegmentedControl.isHidden = false
                            topPadding40.isHidden = false
                            searchHeader.isHidden = true
                            topPadding36.isHidden = true
                            searchTablePresented = false
                            searchIsSelect = false
                            
                            if stockTablePresented == true {
                                getStocks(requestNeedsCancel: false)
                            } else if favouriteTablePresented == true {
                                getFavouriteStocks()
                            } else {
                                getSearch(request: value)
                            }
                        }
                    }
    }
    
    private func setupTopBars() {

        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationItem.titleView = titleView
    }
    
    @objc func didTapView(){
        self.navigationItem.titleView?.endEditing(true)
    }
}

//MARK: Table Delegate/DataSource
extension StockViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stockViewModel.cells.count
    }
    
    
    func tableView (_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 76
}


    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell  = tableView.dequeueReusableCell(withIdentifier: StocksCell.reuseId) as! StocksCell
        let cellViewModel = stockViewModel.cells[indexPath.row]
        cell.set(viewModel: cellViewModel)
        
        return cell
        
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("select row")
        performSegue(withIdentifier: "Card", sender: tableView.cellForRow(at: indexPath))
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.clear
        cell.selectedBackgroundView = backgroundView
        
        guard let cell = cell as? StocksCell else { return }
        cell.tickerView.layer.cornerRadius = 12
        if (indexPath.row % 2) == 0 {
            let altCellColor: UIColor = #colorLiteral(red: 0.9411764706, green: 0.9568627451, blue: 0.968627451, alpha: 1)
            cell.subView.backgroundColor = altCellColor
            cell.subView.layer.cornerRadius = 16

        } else {
            cell.subView.backgroundColor = .white
        }
        
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(scrollView.contentOffset.y)
        var offSet = scrollView.contentOffset.y
        var offSet2 = scrollView.contentOffset.y
        if (self.lastContentOffset > scrollView.contentOffset.y) {
            
            if scrollView.contentOffset.y < 0 {
                offSet2 = 0
                offSet = 0
            }
                if scrollView.contentOffset.y > 56 {
                    offSet = 56
                }
                navigationController?.navigationBar.transform = .init(translationX: 0, y: -offSet2)

            stackView.transform = .init(translationX: 0, y: -offSet)
                stockTableView.transform = .init(translationX: 0, y: -offSet)

            self.lastContentOffset = scrollView.contentOffset.y
            
            if (scrollView.contentOffset.y <= -scrollView.contentInset.top) {
                self.lastContentOffset = -scrollView.contentInset.top
            }

            
        } else if (self.lastContentOffset < scrollView.contentOffset.y) {
            
            if scrollView.contentOffset.y < 0 {
                offSet2 = 0
                offSet = 0
            }
                if scrollView.contentOffset.y > 56 {
                    offSet = 56
                }
                navigationController?.navigationBar.transform = .init(translationX: 0, y: -offSet2)
            stackView.transform = .init(translationX: 0, y: -offSet)

                stockTableView.transform = .init(translationX: 0, y: -offSet)

            self.lastContentOffset = scrollView.contentOffset.y
            
            if scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.bounds.size.height + scrollView.contentInset.bottom) {
                self.lastContentOffset = scrollView.contentSize.height - scrollView.bounds.size.height + scrollView.contentInset.bottom
            }
        }
        offSetNavBar = offSet2
    }
}