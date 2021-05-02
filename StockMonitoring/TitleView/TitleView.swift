//
//  TitleView.swift
//  StockMonitoring
//
//  Created by Александр on 14.04.2021.
//

import Foundation
import UIKit

class TitleView: UIView {
    
    
     var myTextField = InsetableTextField()
    

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(myTextField)
        makeConstraints()
    }
    
    
    private func makeConstraints() {
        
        // Creating constraints using NSLayoutConstraint
        NSLayoutConstraint(item: myTextField,
                           attribute: .leading,
                           relatedBy: .equal,
                           toItem: self.safeAreaLayoutGuide,
                           attribute: .leadingMargin,
                           multiplier: 1.0,
                           constant: 0.0).isActive = true

        NSLayoutConstraint(item: myTextField,
                           attribute: .trailing,
                           relatedBy: .equal,
                           toItem: self.safeAreaLayoutGuide,
                           attribute: .trailingMargin,
                           multiplier: 1.0,
                           constant: 0.0).isActive = true
        
        NSLayoutConstraint(item: myTextField,
                           attribute: .top,
                           relatedBy: .equal,
                           toItem: self.safeAreaLayoutGuide,
                           attribute: .topMargin,
                           multiplier: 1.0,
                           constant: 16.0).isActive = true

        NSLayoutConstraint(item: myTextField,
                           attribute: .bottom,
                           relatedBy: .equal,
                           toItem: self.safeAreaLayoutGuide,
                           attribute: .bottomMargin,
                           multiplier: 1.0,
                           constant: 20.0).isActive = true
    }
    
    override var intrinsicContentSize: CGSize {
        return UIView.layoutFittingExpandedSize
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}


