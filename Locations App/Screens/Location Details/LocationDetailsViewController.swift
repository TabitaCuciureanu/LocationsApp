//
//  LocationDetailsViewController.swift
//  Locations App
//
//  Created by Tabita Marusca on 27/10/2020.
//  Copyright © 2020 Tabita Marusca. All rights reserved.
//

import UIKit

enum ScreenType {
    case addNew, detail, edit
}

enum PhotoSource {
    case gallery, camera
}

final class LocationDetailsViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // MARK: - Properties
    
    private let labelView = LabeledTextField()
    private let addressView = LabeledTextField()
    private let latitudeView = LabeledTextField()
    private let longitudeView = LabeledTextField()
    private let saveButton = UIButton()
    private let scrollView = UIScrollView()
    
    private let type: ScreenType
    private let viewModel: LocationDetailsViewModel
    private let router: Router
    
    // MARK: - Init
    
    init(router: Router, type: ScreenType, viewModel: LocationDetailsViewModel) {
        self.router = router
        self.type = type
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - ViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        setupUI()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: - Private Methods
    
    private func setupUI() {
        labelView.translatesAutoresizingMaskIntoConstraints = false
        labelView.setupStrings(firstString: viewModel.labelTitle, secondString: viewModel.label, textFieldIsEnabled: type == .addNew)
        labelView.delegate = self
        
        addressView.translatesAutoresizingMaskIntoConstraints = false
        addressView.setupStrings(firstString: viewModel.addressTitle, secondString: viewModel.address, textFieldIsEnabled: type == .addNew)
        addressView.delegate = self
        
        latitudeView.translatesAutoresizingMaskIntoConstraints = false
        latitudeView.setupStrings(firstString: viewModel.latitudeTitle, secondString: viewModel.latitudeString, textFieldIsEnabled: type == .addNew)
        latitudeView.delegate = self
        
        longitudeView.translatesAutoresizingMaskIntoConstraints = false
        longitudeView.setupStrings(firstString: viewModel.longitudeTitle, secondString: viewModel.longitudeString, textFieldIsEnabled: type == .addNew)
        longitudeView.delegate = self
        
        saveButton.setTitle(viewModel.saveTitle, for: .normal)
        saveButton.setTitleColor(.systemRed, for: .normal)
        saveButton.setTitleColor(.systemGray, for: .disabled)
        saveButton.contentMode = .scaleAspectFit
        saveButton.isEnabled = false
        saveButton.addTarget(self, action: #selector(saveNewLocation), for: .touchUpInside)
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.isHidden = type != .addNew
        
        let stackView = UIStackView(arrangedSubviews: [
            labelView,
            addressView,
            latitudeView,
            longitudeView,
            saveButton
        ])
        
        view.addSubview(stackView)
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fill
        stackView.alignment = .fill
        
        NSLayoutConstraint.activate([
            saveButton.heightAnchor.constraint(equalToConstant: 40),
            
            stackView.widthAnchor.constraint(equalToConstant: 300),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
    private func checkEnablingSave() {
        guard !labelView.isEmpty,
            !addressView.isEmpty,
            !latitudeView.isEmpty
            else { return }
        
        saveButton.isEnabled = true
    }
    
    @objc private func saveNewLocation() {
        guard let label = labelView.text, let address = addressView.text, let latitude = Double(latitudeView.text ?? ""), let longitude = Double(longitudeView.text ?? "") else {
            return
        }
        viewModel.saveNewLocation(label: label, address: address, coordinate: Coordinate(latitude: latitude, longitude: longitude))
        navigationController?.popViewController(animated: true)
    }
    
    private func savedSuccessfully() {
        self.showAlert(title: "Location added successfully!", message: nil) { _ in
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardFrame = keyboardSize.cgRectValue
        if self.view.frame.origin.y == 0 {
            self.view.frame.origin.y -= keyboardFrame.height / 2.3
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardFrame = keyboardSize.cgRectValue
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y += keyboardFrame.height / 2.3
        }
    }
}

extension LocationDetailsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case labelView.textField:
            addressView.textField.becomeFirstResponder()
        case addressView.textField:
            latitudeView.textField.becomeFirstResponder()
        case latitudeView.textField:
            longitudeView.textField.becomeFirstResponder()
        default:
            longitudeView.textField.resignFirstResponder()
        }
        checkEnablingSave()

        return true
    }
}
