//
//  FoodDetailsView.swift
//  IsItGood
//
//  Created by Yosvani Lopez on 7/28/18.
//  Copyright © 2018 Yosvani Lopez. All rights reserved.
//

import UIKit
import IoniconsSwift

class FoodDetailsView: UIView {
    let scoreView: CustomInsetLabel = {
        let label = CustomInsetLabel()
        label.layer.cornerRadius = 10.0
        label.layer.masksToBounds = true
        label.textAlignment = .center
        label.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        label.font = UIFont.boldSystemFont(ofSize: 40)
        label.textColor = .red
        label.text = "25"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let infoCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.headerReferenceSize = CGSize(width: 100, height: 100)
        let collection = UICollectionView(frame: CGRect(), collectionViewLayout: layout)
        collection.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        collection.bounces = false
        collection.layer.cornerRadius = 20
        collection.clipsToBounds = true
        collection.showsVerticalScrollIndicator = false
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.register(InfoCell.self, forCellWithReuseIdentifier: InfoCell.id)
        collection.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: HeaderView.id)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.restorationIdentifier = "InfoCollection"
        return collection
    }()
    let getButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .red
        button.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        button.layer.cornerRadius = 10
        button.setTitle("Get", for: .normal)
        button.clipsToBounds = true
        return button
    }()
    var food: Food!
    var parent: UIViewController!
    
    @objc init(food: Food, parent: UIViewController, getAction: Selector) {
        self.parent = parent
        self.food = food 
        super.init(frame: CGRect())
        self.translatesAutoresizingMaskIntoConstraints = false
        getButton.addTarget(parent, action: getAction, for: .touchUpInside)
        guard let collectionDelegate = parent as? UICollectionViewDelegate, let collectionDatasource = parent as? UICollectionViewDataSource else { return}
        infoCollection.delegate = collectionDelegate
        infoCollection.dataSource = collectionDatasource
     
    }
    
    func layout() {
        parent.view.addSubview(self)
        self.topAnchor.constraint(equalTo: parent.view.topAnchor).isActive = true
        self.bottomAnchor.constraint(equalTo: parent.view.bottomAnchor).isActive = true
        self.leftAnchor.constraint(equalTo: parent.view.leftAnchor).isActive = true
        self.rightAnchor.constraint(equalTo: parent.view.rightAnchor).isActive = true
        layoutScoreView()
        layoutGetButton()
        layoutInfoCollectionView()
    }
    
    private func layoutScoreView() {
        self.addSubview(scoreView)
        scoreView.topAnchor.constraint(equalTo: self.topAnchor, constant: 60).isActive = true
        scoreView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        scoreView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
        scoreView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
        scoreView.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }

    private func layoutInfoCollectionView() {
        self.addSubview(infoCollection)
        infoCollection.bottomAnchor.constraint(equalTo: getButton.topAnchor, constant: -20).isActive = true
        infoCollection.topAnchor.constraint(equalTo: scoreView.bottomAnchor, constant: 10).isActive = true
        infoCollection.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
        infoCollection.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
    }
    
    private func layoutGetButton() {
        self.addSubview(getButton)
        getButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20).isActive = true
        getButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
        getButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
        getButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
