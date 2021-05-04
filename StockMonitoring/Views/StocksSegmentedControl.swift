//
//  StocksSegmentedController.swift
//  StockMonitoring
//
//  Created by Александр on 16.04.2021.
//

import Foundation
import UIKit

protocol StocksSegmentedControlDelegate:class {
    func change(to index:Int)
}

class StocksSegmentedControl: UIView {
    private var buttonTitles:[String]!
    private var buttons: [UIButton]!
    
    var textColor:UIColor = .gray
    var selectorTextColor: UIColor = .black
    
    weak var delegate:StocksSegmentedControlDelegate?
    
    public private(set) var selectedIndex : Int = 0
    
    convenience init(frame:CGRect,buttonTitle:[String]) {
        self.init(frame: frame)
        self.buttonTitles = buttonTitle
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.backgroundColor = UIColor.white
        updateView()
    }
    
    func setButtonTitles(buttonTitles:[String]) {
        self.buttonTitles = buttonTitles
        self.updateView()
    }
    
    @objc func buttonAction(sender:UIButton) {
        if !self.isHidden {
        for (buttonIndex, btn) in buttons.enumerated() {
            btn.setTitleColor(textColor, for: .normal)
            btn.titleLabel?.font = UIFont(name: "Montserrat-Bold", size: 18)
            if btn == sender {
                selectedIndex = buttonIndex
                delegate?.change(to: selectedIndex)
                btn.setTitleColor(selectorTextColor, for: .normal)
                btn.titleLabel?.font = UIFont(name: "Montserrat-Bold", size: 28)
            }
        }
        }
    }
    
    func setIndex(index:Int) {
        buttons.forEach({ $0.setTitleColor(textColor, for: .normal) })
        let button = buttons[index]
        selectedIndex = index
        button.setTitleColor(selectorTextColor, for: .normal)
        UIView.animate(withDuration: 0.2) {
        }
    }
}


// MARK: Configuration View
extension StocksSegmentedControl {
    private func updateView() {
        createButton()
        configStackView()
    }
    
    private func configStackView() {
        let stack = UIStackView(arrangedSubviews: buttons)
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fillProportionally
        stack.spacing = 20
        addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        stack.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        stack.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
    }

    private func createButton() {
        buttons = [UIButton]()
        buttons.removeAll()
        subviews.forEach({$0.removeFromSuperview()})
        for buttonTitle in buttonTitles {
            let button = UIButton(type: .system)
            button.setTitle(buttonTitle, for: .normal)
            button.addTarget(self, action:#selector(StocksSegmentedControl.buttonAction(sender:)), for: .touchUpInside)
            button.setTitleColor(textColor, for: .normal)
            button.titleLabel?.font =  UIFont(name: "Montserrat-Bold", size: 18)
            button.contentHorizontalAlignment = .left
            buttons.append(button)
        }
        buttons[selectedIndex].setTitleColor(selectorTextColor, for: .normal)
        buttons[selectedIndex].titleLabel?.font = UIFont(name: "Montserrat-Bold", size: 28)
    }
}
