//
//  FoodCell.swift
//  IsItGood
//
//  Created by Yosvani Lopez on 7/28/18.
//  Copyright © 2018 Yosvani Lopez. All rights reserved.
//

import UIKit

class FoodCell: UICollectionViewCell {
    // MARK: - Variables
    static let id = "FoodCell"
    
    // MARK: - Subview
    let foodImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        return view
    }()
    let scoreLabel: CustomInsetLabel = {
        let label = CustomInsetLabel()
        label.text = "20"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let foodLabel: CustomInsetLabel = {
        let label = CustomInsetLabel()
        label.text = "Food Name"
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
    func setup(food: Food) {
        backgroundColor = .clear
        foodLabel.text = food.name
        scoreLabel.text = String(food.score)
        layout()
    }
    
    private func setImage() {
        
    }
    
    private func setDistance(distance: Double) {
       
    }
    
    // MARK: Layout
    private func layout() {
        layoutDirectionalImageView()
        layoutLabelStack()
    }
    
    private func layoutDirectionalImageView() {
        addSubview(foodImageView)
        foodImageView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        foodImageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        foodImageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        foodImageView.widthAnchor.constraint(equalToConstant: 60).isActive = true
    }
    
    private func layoutLabelStack() {
        addSubview(labelStack)
        labelStack.addArrangedSubview(scoreLabel)
        labelStack.addArrangedSubview(foodLabel)
        labelStack.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        labelStack.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
        labelStack.leftAnchor.constraint(equalTo: foodImageView.rightAnchor, constant: 20).isActive = true
    }

}
