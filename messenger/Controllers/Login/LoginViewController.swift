//
//  LoginViewController.swift
//  messenger
//
//  Created by Лада Тирбах on 15.05.2021.
//

import UIKit

class LoginViewController: UIViewController {
    private let scrollView: UIScrollView = {
        let scrollView = LoginCommon.getScrollView()
        return scrollView
    }()
    
    private let imageView: UIImageView = {
        let imageView = LoginCommon.getImageView()
        imageView.image = UIImage(named: "logo")
        imageView.layer.cornerRadius = 65
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.gray.cgColor
        return imageView
    }()
    
    private let emailField: UITextField = {
        let field = LoginCommon.getTextField()
        field.returnKeyType = .continue
        field.placeholder = "Email"
        return field
    }()
    
    private let passwordField: UITextField = {
        let field = LoginCommon.getTextField()
        field.returnKeyType = .done
        field.placeholder = "Пароль"
        field.isSecureTextEntry = true
        return field
    }()
    
    private let loginButtun: UIButton = {
        let button = LoginCommon.getButton()
        button.setTitle("Войти", for: .normal)
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Войти"
        view.backgroundColor = .white
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Регистрация",
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(didTapRegister))
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(emailField)
        scrollView.addSubview(passwordField)
        scrollView.addSubview(loginButtun)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = view.bounds
        
        loginButtun.addTarget(self, action: #selector(didTapLoginButton), for: .touchUpInside)
        
        emailField.delegate = self
        passwordField.delegate =  self
        
        let bufferSize: CGFloat = 15
        imageView.frame = LoginCommon.getCGRectImage(scrollView, bufferSize * 4)
        emailField.frame = LoginCommon.getCGRectField(scrollView, imageView.bottom + bufferSize * 2)
        passwordField.frame = LoginCommon.getCGRectField(scrollView, emailField.bottom + bufferSize)
        loginButtun.frame = LoginCommon.getCGRectField(scrollView, passwordField.bottom + bufferSize)
    }
    
    @objc private func didTapLoginButton() {
        LoginCommon.resiginAll([emailField, passwordField])
        
        guard !emailField.text!.isEmpty && !passwordField.text!.isEmpty else {
            emptyFieldsErrorAlert()
            return
        }
        
        //Firebase login
    }
    
    private func emptyFieldsErrorAlert() {
        let alert = LoginCommon.getFieldsValidationErrorAlert(body: "Поля не должны быть пустыми")
        present(alert, animated: true)
    }

    @objc private func didTapRegister() {
        let vc = RegisterViewController()
        
        navigationController?.pushViewController(vc, animated: true)
    }

}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailField {
            passwordField.becomeFirstResponder()
        } else if textField == passwordField {
            didTapLoginButton()
        }
        
        return true
    }
}