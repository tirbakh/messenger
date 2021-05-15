//
//  RegisterViewController.swift
//  messenger
//
//  Created by Лада Тирбах on 15.05.2021.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {
    private let minPasswordLenght = 6

    private let scrollView: UIScrollView = {
        let scrollView = LoginCommon.getScrollView()
        return scrollView
    }()
    
    private let imageView: UIImageView = {
        let imageView = LoginCommon.getImageView()
        imageView.image = UIImage(systemName: "person.circle")
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
        
        nameField.delegate = self
        surnameField.delegate = self
        emailField.delegate = self
        passwordField.delegate = self
        
        let bufferSize: CGFloat = 15
        imageView.frame = LoginCommon.getCGRectImage(scrollView, bufferSize * 3)
        nameField.frame = LoginCommon.getCGRectField(scrollView, imageView.bottom + bufferSize * 2)
        surnameField.frame = LoginCommon.getCGRectField(scrollView, nameField.bottom + bufferSize)
        emailField.frame = LoginCommon.getCGRectField(scrollView, surnameField.bottom + bufferSize)
        passwordField.frame = LoginCommon.getCGRectField(scrollView, emailField.bottom + bufferSize)
        registerButton.frame = LoginCommon.getCGRectField(scrollView, passwordField.bottom + bufferSize)
        
        
        registerButton.addTarget(self, action: #selector(didTapRegisterButton), for: .touchUpInside)
        imageView.layer.cornerRadius = imageView.width/2.0
    }
    
    @objc private func didTapProfilePic() {
        presentPhotoActionSheet()
    }
    
    @objc private func didTapRegisterButton() {
        LoginCommon.resiginAll([nameField, surnameField, emailField, passwordField])
        
        guard let name = nameField.text,
              let surname = surnameField.text,
              let email = emailField.text,
              let password = passwordField.text,
              !name.isEmpty,
              !surname.isEmpty,
              !email.isEmpty,
              !password.isEmpty else {
            errorAlert(message: "Поля не должны быть пустыми")
            return
        }
        
        guard (password.count >= minPasswordLenght) else {
            errorAlert(message: "Пароль должен быть не меньше \(minPasswordLenght) символов")
            return
        }
        
        DatabaseManager.shared.userExists(with: email) { [weak self] userExists in
            guard let strongSelf = self else {
                return
            }
            
            guard !userExists else {
                strongSelf.errorAlert(message: "Пользователь с таким email уже существует")
                return
            }
            
            Firebase.Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
                guard let result = authResult, error == nil else {
                    strongSelf.errorAlert(message: "Что-то пошло не так! \(error?.localizedDescription ?? "")")
                    return
                }
                DatabaseManager.shared.addUser(with: User(name: name,
                                                          surname: surname,
                                                          emailAddress: email))
                
                print(result.additionalUserInfo as Any)
                
                strongSelf.navigationController?.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    private func errorAlert(message body: String) {
        let alert = LoginCommon.getFieldsValidationErrorAlert(body: body)
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

extension RegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
        }
        
        self.imageView.image = selectedImage
    }

    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true, completion: nil)
        }
    
    private func presentPhotoActionSheet() {
        let actionSheet = UIAlertController(title: "Фото профиля", message: "Загрузить фото", preferredStyle: .actionSheet)

        actionSheet.addAction(UIAlertAction(title: "Камера", style: .default, handler: { [weak self] _ in
            self?.presentPhoto(sourceType: .camera)
            
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Галерея", style: .default, handler: { [weak self] _ in
            self?.presentPhoto(sourceType: .photoLibrary)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Отмена", style: .default, handler: nil))
        
        present(actionSheet, animated: true)
    }
    
    private func presentPhoto(sourceType: UIImagePickerController.SourceType) {
        let vc = UIImagePickerController()
        vc.sourceType = sourceType
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    
}
