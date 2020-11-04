//
//  WorkoutHistoryCell.swift
//  Workout App
//
//  Created by Tabita Marusca on 29/10/2020.
//  Copyright © 2020 Tabita Marusca. All rights reserved.
//

import UIKit

final class WorkoutHistoryCell: UITableViewCell {
    // MARK: - Properties
    
    private let nameLabel = LabeledTextField()
    private let dateLabel = LabeledTextField()
    private let photoView = UIImageView()
    
    // MARK: - Internal Methods
    
    func configure(name: String, date: String, photo: UIImage?) {
        nameLabel.setupStrings(firstString: "Name", secondString: name)
        dateLabel.setupStrings(firstString: "Date", secondString: date)
        photoView.image = photo
        setupUI()
    }
    
    // MARK: - Private Methods
    
    private func setupUI() {
        addSubview(photoView)
        
        let labelsView = UIView()
        addSubview(labelsView)
        labelsView.addSubview(nameLabel)
        labelsView.addSubview(dateLabel)
        
        labelsView.translatesAutoresizingMaskIntoConstraints = false
        photoView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let constraint = photoView.widthAnchor.constraint(equalToConstant: 60)
        constraint.priority = UILayoutPriority(rawValue: 999)
        
        NSLayoutConstraint.activate([
            labelsView.trailingAnchor.constraint(equalTo: photoView.leadingAnchor),
            labelsView.centerYAnchor.constraint(equalTo: photoView.centerYAnchor),
            labelsView.leadingAnchor.constraint(equalTo: readableContentGuide.leadingAnchor, constant: 20),
            labelsView.topAnchor.constraint(equalTo: readableContentGuide.topAnchor, constant: 10),
            labelsView.bottomAnchor.constraint(equalTo: readableContentGuide.bottomAnchor, constant: -10),
            
            nameLabel.trailingAnchor.constraint(equalTo: labelsView.trailingAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: labelsView.leadingAnchor),
            nameLabel.topAnchor.constraint(equalTo: labelsView.topAnchor),
            
            dateLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            dateLabel.topAnchor.constraint(greaterThanOrEqualTo: nameLabel.bottomAnchor, constant: 20),
            dateLabel.bottomAnchor.constraint(equalTo: labelsView.bottomAnchor),
            
            photoView.trailingAnchor.constraint(equalTo: readableContentGuide.trailingAnchor, constant: -20),
            photoView.topAnchor.constraint(equalTo: readableContentGuide.topAnchor, constant: 10),
            photoView.bottomAnchor.constraint(equalTo: readableContentGuide.bottomAnchor, constant: -10),
            photoView.centerYAnchor.constraint(equalTo: centerYAnchor),
            photoView.heightAnchor.constraint(equalTo: photoView.widthAnchor),
            constraint
        ])
    }
}
