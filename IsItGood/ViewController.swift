//
//  ViewController.swift
//  IsItGood
//
//  Created by Yosvani Lopez on 7/28/18.
//  Copyright © 2018 Yosvani Lopez. All rights reserved.
//

import UIKit
import IoniconsSwift

class ViewController: UIViewController{
    let searchBar: UISearchBar = {
        let view = UISearchBar()
        view.placeholder = "Search Foods"
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let takeAPhotoButton: UIButton = {
        let button = UIButton()
        button.setTitle("Test", for: .normal)
        button.setTitleColor(UIView().tintColor, for: .normal)
        button.layer.borderColor = UIView().tintColor.cgColor
        button.addTarget(self, action: #selector(showCameraViewController), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        searchBar.delegate = self
        layout()
    }
    
    private func layout() {
        layoutSearchBar()
        layoutTakeAPhotoButton()
    }
    
    private func layoutSearchBar() {
        view.addSubview(searchBar)
        searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        searchBar.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        searchBar.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
    }
    
    private func layoutTakeAPhotoButton() {
        view.addSubview(takeAPhotoButton)
        takeAPhotoButton.heightAnchor.constraint(equalToConstant: 100).isActive = true
        takeAPhotoButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        takeAPhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        takeAPhotoButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    @objc func showCameraViewController() {
        present(CameraSessionVC(), animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension ViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        view.resignFirstResponder()
        present(searchVC(), animated: true, completion: nil)
    }
}
