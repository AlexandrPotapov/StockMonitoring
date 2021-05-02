//
//  InsertebleTextField.swift
//  StockMonitoring
//
//  Created by Александр on 14.04.2021.
//

import Foundation
import UIKit

protocol TextFieldDidChange:class {
    func textFieldDidChange(to value: String, isChange:Bool)
}

class InsetableTextField: UITextField {
    
    var textPadding = UIEdgeInsets(
        top: 12,
        left: 21,
        bottom: 12,
        right: 29
    )
    
    var leftItemIsArrow = false
    
    weak var customDelegate:TextFieldDidChange?

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .white
        font = UIFont(name: "Montserrat-Bold", size: 16)
        attributedPlaceholder = NSAttributedString(string: "Find company or ticker",
                                                   attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        InsetableTextField.appearance().tintColor = .black
        layer.cornerRadius = 24
        layer.borderWidth = 1.0
        layer.masksToBounds = true
        layer.borderColor = CGColor(red: 9/255, green: 20/255, blue: 31/255, alpha: 1)
        
        let image = UIImage(named: "Ellipse 434")
        let paddingView = UIView(frame: CGRect(x: 8, y: 0, width: 15, height: 16))
        let imageView = UIImageView (frame:CGRect(x: 0, y: 0, width: 15 , height: 16))

        imageView.center = paddingView.center
        imageView.image  = image
        paddingView .addSubview(imageView)
        leftView = paddingView
        leftViewMode = .always
        
        let paddingRightView = UIView(frame: CGRect(x: -5, y: 0, width: 16, height: 16))
        let clearButton = UIButton(frame: CGRect(origin: .zero, size: CGSize(width: 16, height: 16)))
        clearButton.setImage(UIImage(named: "cross")!, for: UIControl.State.normal)
        clearButton.center = paddingRightView.center
        paddingRightView.addSubview(clearButton)
        rightView = paddingRightView
        clearButton.addTarget(self, action:#selector(clearClicked), for:.touchUpInside)
        self.rightViewMode = .never
        
        self.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        self.addTarget(self, action: #selector(textFieldDidBeginEditing), for: .editingDidBegin)
        self.addTarget(self, action: #selector(textFieldDidEndEditing), for: .editingDidEnd)   
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.textRect(forBounds: bounds)
        return rect.inset(by: textPadding)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.editingRect(forBounds: bounds)
        return rect.inset(by: textPadding)
    }
    
    @objc func textFieldDidBeginEditing() {
        self.placeholder = ""
        if let text = self.text {
                self.customDelegate?.textFieldDidChange(to: text, isChange: true)
        }
    
        let image = UIImage(named: "Arrow")
        let paddingView = UIView(frame: CGRect(x: 8, y: 0, width: 20, height: 14))
        let returnButton = UIButton(frame: CGRect(origin: .zero, size: CGSize(width: 20, height: 14)))
        returnButton.setImage(UIImage(named: "Arrow")!, for: UIControl.State.normal)
        returnButton.center = paddingView.center
        paddingView .addSubview(returnButton)
        leftView = paddingView
        leftViewMode = .always
        returnButton.addTarget(self, action:#selector(returnClicked), for:.touchUpInside)

    }
    
    @objc func textFieldDidEndEditing() {
        self.placeholder = "Find company or ticker"
        self.customDelegate?.textFieldDidChange(to: self.text!, isChange: false)
        
        if self.text == "" {
        let image = UIImage(named: "Ellipse 434")
        let paddingView = UIView(frame: CGRect(x: 8, y: 0, width: 15, height: 16))
        let imageView = UIImageView (frame:CGRect(x: 0, y: 0, width: 15 , height: 16))

        imageView.center = paddingView.center
        imageView.image  = image
        paddingView .addSubview(imageView)
        leftView = paddingView
        leftViewMode = .always
        }
    }
    
    @objc func clearClicked(sender: UIButton) {
        self.text = ""
        self.rightViewMode = .never

        self.customDelegate?.textFieldDidChange(to: "", isChange: true)
        
    }
    
    @objc func returnClicked(sender: UIButton) {
        self.text = ""
        
        let image = UIImage(named: "Ellipse 434")
        let paddingView = UIView(frame: CGRect(x: 8, y: 0, width: 15, height: 16))
        let imageView = UIImageView (frame:CGRect(x: 0, y: 0, width: 15 , height: 16))

        imageView.center = paddingView.center
        imageView.image  = image
        paddingView .addSubview(imageView)
        leftView = paddingView
        leftViewMode = .always
        self.endEditing(true)
        self.customDelegate?.textFieldDidChange(to: "", isChange: false)

    }
    
    @objc func textFieldDidChange() {
        if let text = self.text {
            self.customDelegate?.textFieldDidChange(to: text, isChange: true)
            if text != "" {
                self.rightViewMode = .whileEditing
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 42, dy: 0)
    }
    
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.leftViewRect(forBounds: bounds)
        rect.origin.x += 12
        return rect
    }
    
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.rightViewRect(forBounds: bounds)
        rect.origin.x -= 12
        return rect
    }
}
