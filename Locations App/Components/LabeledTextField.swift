//
//  DoubleLabel.swift
//  Locations App
//
//  Created by Tabita Marusca on 29/10/2020.
//  Copyright © 2020 Tabita Marusca. All rights reserved.
//

import UIKit

final class LabeledTextField: UIView {
    // MARK: - Properties
    
    private let label = UILabel()
    let textField = UITextField()
    
    var delegate: UITextFieldDelegate? {
        didSet {
            textField.delegate = delegate
        }
    }
    var isEmpty: Bool {
        return textField.text?.isEmpty ?? true
    }
    var text: String? {
        return textField.text
    }
    
    // MARK: - Init
    
    init() {
        super.init(frame: .zero)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Internal Methods
    
    func setupStrings(firstString: String?, secondString: String?, textFieldIsEnabled: Bool = false) {
        label.text = firstString
        textField.text = secondString
        
        textField.isEnabled = textFieldIsEnabled
        textField.borderStyle = textFieldIsEnabled ? .roundedRect : .none
    }
    
    // MARK: - Private Methods
    
    private func setupUI() {
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 14)
        
        let stackView = UIStackView(arrangedSubviews: [
            label,
            textField
        ])
        
        addSubview(stackView)
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
