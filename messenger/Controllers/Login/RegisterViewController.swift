//
//  RegisterViewController.swift
//  messenger
//
//  Created by Лада Тирбах on 15.05.2021.
//

import UIKit

class RegisterViewController: UIViewController {

    private let scrollView: UIScrollView = {
        let scrollView = LoginCommon.getScrollView()
        return scrollView
    }()
    
    private let imageView: UIImageView = {
        let imageView = LoginCommon.getImageView()
        imageView.image = UIImage(systemName: "person")
        imageView.tintColor = .gray
        return imageView
    }()
    
    private let nameField: UITextField = {
        let field = LoginCommon.getTextField()
        field.returnKeyType = .continue
        field.placeholder = "Имя"
        return field
    }()
    
    private let surnameField: UITextField = {
        let field = LoginCommon.getTextField()
        field.returnKeyType = .continue
        field.placeholder = "Фамилия"
        return field
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
    
    private let registerButton: UIButton = {
        let button = LoginCommon.getButton()
        button.backgroundColor = .systemGreen
        button.setTitle("Зарегистрироваться", for: .normal)
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Регистрация"
        view.backgroundColor = .white
        
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(nameField)
        scrollView.addSubview(surnameField)
        scrollView.addSubview(emailField)
        scrollView.addSubview(passwordField)
        scrollView.addSubview(registerButton)
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapProfilePic))
        imageView.addGestureRecognizer(gesture)
        imageView.isUserInteractionEnabled = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = view.bounds
        
        registerButton.addTarget(self, action: #selector(didTapRegisterButton), for: .touchUpInside)
        
        nameField.delegate = self
        surnameField.delegate = self
        emailField.delegate = self
        passwordField.delegate = self
        
        let bufferSize: CGFloat = 15
        imageView.frame = LoginCommon.getCGRectImage(scrollView, bufferSize * 4)
        nameField.frame = LoginCommon.getCGRectField(scrollView, imageView.bottom + bufferSize * 2)
        surnameField.frame = LoginCommon.getCGRectField(scrollView, nameField.bottom + bufferSize)
        emailField.frame = LoginCommon.getCGRectField(scrollView, surnameField.bottom + bufferSize)
        passwordField.frame = LoginCommon.getCGRectField(scrollView, emailField.bottom + bufferSize)
        registerButton.frame = LoginCommon.getCGRectField(scrollView, passwordField.bottom + bufferSize)
    }
    
    @objc private func didTapProfilePic() {
        print("tapped")
    }
    
    @objc private func didTapRegisterButton() {
        LoginCommon.resiginAll([nameField, surnameField, emailField, passwordField])
        
        guard !nameField.text!.isEmpty && !surnameField.text!.isEmpty && !emailField.text!.isEmpty && !passwordField.text!.isEmpty else {
            emptyFieldsErrorAlert()
            return
        }
        
        guard (passwordField.text!.count > 5) else {
            shortPasswordErrorAlert()
            return
        }
        
        //Firebase register
    }
    
    private func emptyFieldsErrorAlert() {
        let alert = LoginCommon.getFieldsValidationErrorAlert(body: "Поля не должны быть пустыми")
        present(alert, animated: true)
    }
    
    private func shortPasswordErrorAlert() {
        let alert = LoginCommon.getFieldsValidationErrorAlert(body: "Пароль должен быть не меньше 6 символов")
        present(alert, animated: true)
    }
}

extension RegisterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        switch textField {
        case nameField:
            surnameField.becomeFirstResponder()
        case surnameField:
            emailField.becomeFirstResponder()
        case emailField:
            passwordField.becomeFirstResponder()
        default:
            didTapRegisterButton()
        }
        
        return true
    }
}
