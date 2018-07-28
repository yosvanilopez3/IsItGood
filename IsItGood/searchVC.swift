//
//  searchVC.swift
//  IsItGood
//
//  Created by Yosvani Lopez on 7/28/18.
//  Copyright © 2018 Yosvani Lopez. All rights reserved.
//

import UIKit

class searchVC: UIViewController {
    let searchBar: UISearchBar = {
        let view = UISearchBar()
        view.placeholder = "Food Products"
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let foodList: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.headerReferenceSize = CGSize.init(width: 100, height: 20)
        layout.footerReferenceSize = CGSize.init(width: 100, height: 20)
        let collection = UICollectionView(frame: CGRect(), collectionViewLayout: layout)
        collection.backgroundColor = .clear
        collection.bounces = false
        collection.showsVerticalScrollIndicator = false
        collection.translatesAutoresizingMaskIntoConstraints = false
        // register the cell type
        return collection
    }()

    var bottomConstraint: NSLayoutConstraint?
    var foods: [Food] = []
    var filteredFoods: [Food] = []
    
    // MARK: - View Presentation
    override func viewDidLoad() {
        view.backgroundColor = .white
        searchBar.delegate = self
        searchBar.becomeFirstResponder()
        layout()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardDidShow),
            name: NSNotification.Name.UIKeyboardDidShow,
            object: nil
        )
    }
    
    @objc func keyboardDidShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            guard let bottomContraint = self.bottomConstraint else {
                return
            }
            
            bottomContraint.constant = -keyboardHeight + 50
            UIView.animate(withDuration: 0.5, animations: {
                self.view.layoutIfNeeded()
            })
        }
    }
    
    // MARK: - Layout
    private func layout() {
        layoutSearchBar()
        layoutFoodList()
    }
    
    private func layoutSearchBar() {
        view.addSubview(searchBar)
        searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        searchBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        searchBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
    }
    
    private func layoutFoodList() {
        view.addSubview(foodList)
        foodList.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 0).isActive = true
        foodList.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        foodList.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        bottomConstraint = foodList.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        view.addConstraint(bottomConstraint!)
    }
    
    
}

// MARK: - SearchBar Data Handler
extension searchVC: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredFoods = foods.filter { (product) -> Bool in
            return true// apply the filters
        }
        foodList.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - CollectionView Layout
extension searchVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 20
        let cellHeight: CGFloat = 100
        let cellWidth: CGFloat = view.frame.width - padding*2
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
}

// MARK: - CollectionView Data Handler
extension searchVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredFoods.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
        
//        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "", for: indexPath) as? ProductCell {
//            cell.setup(product: filteredFoods[indexPath.row])
//            return cell
//        }
//        return ProductCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // pass the data to the food detail vc
        let foodDetailVC = FoodDetailVC()
        navigationController?.pushViewController(foodDetailVC, animated: true)
    }
}
