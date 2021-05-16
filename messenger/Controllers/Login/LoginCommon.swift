//
//  Views.swift
//  messenger
//
//  Created by Лада Тирбах on 15.05.2021.
//

import Foundation
import UIKit
import JGProgressHUD

class LoginCommon {
    class func getTextField() -> UITextField {
        let field = UITextField()
        field.autocorrectionType = .no
        field.autocapitalizationType = .none
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .white
        return field
    }
    
    class func getImageView() ->  UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.gray.cgColor
        imageView.clipsToBounds = true
        return imageView
    }
    
    class func getScrollView() -> UIScrollView {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        return scrollView
    }
    
    class func getButton() -> UIButton {
        let button = UIButton()
        button.backgroundColor = .link
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        return button
    }
    
    class func getCGRectImage(_ view: UIView, _ y: CGFloat) -> CGRect {
        let size = view.width/3
        return CGRect(x: (view.width-size)/2,
                      y: y,
                      width: size,
                      height: size)
    }
    
    class func getCGRectField(_ view: UIView, _ y: CGFloat) -> CGRect {
        return CGRect(x: 30,
                      y: y,
                      width: view.width - 60,
                      height: 52)
    }
    
    class func getFieldsValidationErrorAlert(body message: String) -> UIAlertController {
        let alert = UIAlertController(title: "Упс!", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ок", style: .default, handler: nil)
        alert.addAction(action)
        return alert
        
    }
    
    class func resiginAll(_ fields: [UITextField]) {
        for field in fields {
            field.resignFirstResponder()
        }
    }
}
