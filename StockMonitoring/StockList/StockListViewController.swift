//
//  StockViewController.swift
//  StockMonitoring
//
//  Created by Александр on 30.03.2021.


import UIKit


protocol StockListViewProtocol: class {
  var selfToCardSegueName: String { get }
    func reloadData()
  func changeCegment(to index: Int)
  func updatedStockFavouriteStatus(isFavourite: Bool, indexPath: IndexPath)
}

class StockListViewController: UIViewController  {

  

  var presenter: StockListPresenterProtocol!
  let selfToCardSegueName = "Card"

  private let configurator: StockListConfiguratorProtocol = StockListCofigurator()

    
    @IBOutlet weak var stockSegmentedControl: StocksSegmentedControl! {
        didSet{
            stockSegmentedControl.setButtonTitles(buttonTitles: ["Stocks","Favourite"])
            stockSegmentedControl.selectorTextColor = UIColor(red: 2/255, green: 2/255, blue: 2/255, alpha: 1)
        }
    }
    @IBOutlet weak var stockTableView: UITableView!


    
    // MARK: Routing
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
      if segue.identifier == selfToCardSegueName {
          guard let stock = sender as? (IndexPath, Stock) else { return }
          let cardVC = segue.destination as! CardViewController
          let configurator: CardConfiguratorProtocol = CardConfigurator()
          configurator.configure(with: cardVC, and: stock.1, indexPath: stock.0, delegate: self)
      }
    }
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
      configurator.configure(with: self)
      presenter.viewDidLoad()
      

      navigationController?.isNavigationBarHidden = true

        stockSegmentedControl.delegate = self
        
        let stockCell = UINib(nibName: "StocksCell", bundle: nil)
        stockTableView.register(stockCell , forCellReuseIdentifier: StocksCell.reuseId)

    }


      override func viewWillAppear(_ animated: Bool) {
        
      }


}

//MARK: Table Delegate/DataSource
extension StockListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return presenter.stocksCount ?? 0
    }
    
    
//    func tableView (_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 76
//}


    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell  = tableView.dequeueReusableCell(withIdentifier: StocksCell.reuseId) as! StocksCell
      guard let stock = presenter.stock(atIndex: indexPath) else { return UITableViewCell() }
      cell.set(stock: stock)
        
        return cell
        
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      tableView.deselectRow(at: indexPath, animated: true)
      presenter.showCard(for: indexPath)
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
    
}

extension StockListViewController: StockListViewProtocol {

    func reloadData() {
      DispatchQueue.main.async {
          self.stockTableView.reloadData()
      }

  }
  
  
}


extension StockListViewController: CardModuleDelegate {
  func updatedStockFavouriteStatus(isFavourite: Bool, indexPath: IndexPath) {
    presenter.updatedStockFavouriteStatus(isFavourite: isFavourite, indexPath: indexPath)
  }
  
  
}

extension StockListViewController: StocksSegmentedControlDelegate {
  func changeCegment(to index: Int) {
    presenter.changeCegment(to: index)
  }
}
