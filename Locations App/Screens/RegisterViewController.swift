//
//  RegisterViewController.swift
//  Workout App
//
//  Created by Tabita Marusca on 27/10/2020.
//  Copyright © 2020 Tabita Marusca. All rights reserved.
//

import UIKit

final class RegisterViewController: UIViewController {
    // MARK: - Properties
    
    private let emailAddressTextField = UITextField()
    private let passwordTextField = UITextField()
    private let passwordConfirmationTextField = UITextField()
    private let usernameTextField = UITextField()
    private let signupButton = UIButton()
    private let checkbox = UIButton(type: .custom)
    
    private let accountManager: AccountManager
    private weak var router: Router?
    
    // MARK: - Init
    
    init(router: Router, accountManager: AccountManager) {
        self.router = router
        self.accountManager = accountManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - ViewController Lifecycle
    
    override func viewDidLoad() {
        view.backgroundColor = .systemBackground
        setupUI()
    }
    
    // MARK: - Private Methods
    
    private func setupUI() {
        emailAddressTextField.translatesAutoresizingMaskIntoConstraints = false
        emailAddressTextField.placeholder = "E-mail"
        emailAddressTextField.borderStyle = .roundedRect
        emailAddressTextField.delegate = self
        
        passwordTextField.isSecureTextEntry = true
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.placeholder = "Password"
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.delegate = self
        
        passwordConfirmationTextField.isSecureTextEntry = true
        passwordConfirmationTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordConfirmationTextField.placeholder = "Password confirmation"
        passwordConfirmationTextField.borderStyle = .roundedRect
        passwordConfirmationTextField.delegate = self
        
        usernameTextField.translatesAutoresizingMaskIntoConstraints = false
        usernameTextField.placeholder = "Username"
        usernameTextField.borderStyle = .roundedRect
        usernameTextField.delegate = self
        
        signupButton.setTitle("Signup", for: .normal)
        signupButton.setTitleColor(.systemRed, for: .normal)
        signupButton.setTitleColor(.systemGray, for: .disabled)
        signupButton.isEnabled = false
        signupButton.addTarget(self, action: #selector(signup), for: .touchUpInside)
        signupButton.translatesAutoresizingMaskIntoConstraints = false
    
        let acceptTermsLabel = UILabel()
        acceptTermsLabel.textAlignment = .right
        acceptTermsLabel.font = .systemFont(ofSize: 14)
        acceptTermsLabel.text = "Accept terms and conditions"
        
        checkbox.setTitle("X", for: .selected)
        checkbox.setTitle("", for: .normal)
        checkbox.addTarget(self, action: #selector(toggleCheckbox), for: .touchUpInside)
        checkbox.contentMode = .center
        checkbox.setTitleColor(.black, for: .normal)
        checkbox.layer.borderWidth = 1
        checkbox.layer.borderColor = UIColor.black.cgColor
        
        let checkStackView = UIStackView(arrangedSubviews: [
            acceptTermsLabel,
            checkbox
        ])
        
        checkStackView.axis = .horizontal
        checkStackView.spacing = 20
        checkStackView.translatesAutoresizingMaskIntoConstraints = false
        checkStackView.distribution = .fill
        checkStackView.alignment = .center
    
        let stackView = UIStackView(arrangedSubviews: [
            emailAddressTextField,
            passwordTextField,
            passwordConfirmationTextField,
            usernameTextField,
            signupButton,
            checkStackView
        ])
        
        view.addSubview(stackView)
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillProportionally
        stackView.alignment = .fill
        
        NSLayoutConstraint.activate([
            signupButton.heightAnchor.constraint(equalToConstant: 40),
            checkbox.heightAnchor.constraint(equalToConstant: 20),
            checkbox.widthAnchor.constraint(equalToConstant: 20),
            
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.widthAnchor.constraint(equalToConstant: 300)
        ])
    }
    
    @objc private func toggleCheckbox() {
        if !checkbox.isSelected {
            checkEnablingSignup()
        } else {
            signupButton.isEnabled = false
        }
        checkbox.isSelected.toggle()
    }
    
    private func checkEnablingSignup() {
        guard !(emailAddressTextField.text?.isEmpty ?? false),
            !(passwordTextField.text?.isEmpty ?? false),
            !(passwordConfirmationTextField.text?.isEmpty ?? false),
            !(usernameTextField.text?.isEmpty ?? false),
            checkbox.isSelected
            else { return }
        
        signupButton.isEnabled = true
    }
    
    @objc private func signup() {
        guard let email = emailAddressTextField.text,
            let password = passwordTextField.text,
            let confirmationPassword = passwordConfirmationTextField.text,
            let username = usernameTextField.text else { return }
        
        if password != confirmationPassword {
            showAlert(title: "Passwords do not match!", message: nil)
            return
        }
        
        guard email.isValidEmail else {
            showAlert(title: "Invalid email", message: "Please choose a valid email")
            return
        }
        
        
        accountManager.registerNewUser(email: email, password: password, username: username) { [weak self] (error) in
            guard let _ = error else {
                self?.router?.goToWorkoutHistory()
                return
            }
            self?.showAlert(title: "An error occured", message: "The user could not be registered, please try again later")
        }
    }
}

extension RegisterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case emailAddressTextField:
            passwordTextField.becomeFirstResponder()
        case passwordTextField:
            passwordConfirmationTextField.becomeFirstResponder()
        case passwordConfirmationTextField:
            usernameTextField.becomeFirstResponder()
        default:
            textField.resignFirstResponder()
        }
        checkEnablingSignup()
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        checkEnablingSignup()
        return true
    }
}
