//
//  CardViewController.swift
//  StockMonitoring
//
//  Created by Александр on 18.04.2021.

import UIKit


protocol CardViewProtocol: class {
  func setTitle(with title: NSMutableAttributedString)
    func setPrice(with title: String?)
    func setPricePercentChange(with title: String?)
    func setPriceChange(with title: String?)
    func setImageForFavoriteButton()
}

class CardViewController: UIViewController {
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var priceChangeLabel: UILabel!
    @IBOutlet weak var pricePercentChangeLabel: UILabel!
  
  var presenter: CardPresenterProtocol!


    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
      presenter.showCard()
        navigationController?.isNavigationBarHidden = false
    }
    
    @IBAction func returnButtonPressing(_ sender: UIBarButtonItem) {
      presenter.backToStockListViewController()
    }
    @IBAction func favouriteButtonPressing(_ sender: UIBarButtonItem) {
      presenter.favouriteButtonPressed()

    }
}

// MARK: - CardViewProtocol
extension CardViewController: CardViewProtocol {
  
  func setTitle(with title: NSMutableAttributedString) {
    guard let height = navigationController?.navigationBar.frame.size.height else {return}
    let titleLabel = UILabel(frame: CGRect(x: 0,y: 0, width: title.size().width, height: height))
    titleLabel.attributedText = title
    titleLabel.numberOfLines = 0
    titleLabel.textAlignment = .center
    navigationItem.titleView = titleLabel
  }
  
  func setImageForFavoriteButton() {
    navigationItem.rightBarButtonItem?.image = UIImage(named: "Star 1")
    navigationItem.rightBarButtonItem?.tintColor = presenter.isFavourite
      ? UIColor(red: 255/255, green: 202/255, blue: 28/255, alpha: 1)
      : UIColor(red: 9/255, green: 20/255, blue: 31/255, alpha: 1)
    
}

  
  func setPrice(with title: String?) {
    priceLabel.text = title
  }
  
  func setPricePercentChange(with title: String?) {
    priceChangeLabel.text = title
  }
  
  func setPriceChange(with title: String?) {
    pricePercentChangeLabel.text = title
  }
  

}
