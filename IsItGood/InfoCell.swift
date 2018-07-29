//
//  InfoCell.swift
//  IsItGood
//
//  Created by Yosvani Lopez on 7/29/18.
//  Copyright © 2018 Yosvani Lopez. All rights reserved.
//

import UIKit

class InfoCell: UICollectionViewCell {
        // MARK: - Variables
        static let id = "InfoCell"
        
        // MARK: - Subview
        let infoLabel: CustomInsetLabel = {
            let label = CustomInsetLabel()
            label.text = "Distance Instruction"
            label.textColor = .white
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        let labelStack: UIStackView = {
            let stackView = UIStackView()
            stackView.translatesAutoresizingMaskIntoConstraints = false
            stackView.axis = .vertical
            stackView.spacing = 5
            return stackView
        }()
        
        // MARK: - Setup
        func setup(label: String) {
            backgroundColor = .clear
            infoLabel.text = label
            layout()
        }
    
        
        // MARK: Layout
        private func layout() {
            layoutLabelStack()
        }
        
        private func layoutLabelStack() {
            addSubview(labelStack)
            labelStack.addArrangedSubview(infoLabel)
            labelStack.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            labelStack.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
            labelStack.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        }
        
    }

