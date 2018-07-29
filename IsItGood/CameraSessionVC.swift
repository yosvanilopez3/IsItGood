//
//  CameraSessionVC.swift
//  IsItGood
//
//  Created by Yosvani Lopez on 7/28/18.
//  Copyright © 2018 Yosvani Lopez. All rights reserved.
//

import UIKit
import AVKit
import Vision
import IoniconsSwift

class CameraSessionVC: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    let searchBar: UISearchBar = {
        let view = UISearchBar()
        view.placeholder = "Food Products"
        view.backgroundColor = .clear
        view.backgroundImage = UIImage()
        var textFieldInsideSearchBar = view.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = .white
        textFieldInsideSearchBar?.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        textFieldInsideSearchBar?.clearButtonMode = .never
        textFieldInsideSearchBar?.bounds.size.height = 50
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let foodList: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collection = UICollectionView(frame: CGRect(), collectionViewLayout: layout)
        collection.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        collection.bounces = false
        collection.showsVerticalScrollIndicator = false
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.register(FoodCell.self, forCellWithReuseIdentifier: FoodCell.id)
        collection.isHidden = true
        collection.restorationIdentifier = "FoodList"
        // register the cell type
        return collection
    }()
    let scoreView: UILabel = {
        let label = UILabel()
        label.layer.cornerRadius = 25.0
        label.layer.masksToBounds = true
        label.textAlignment = .center
        label.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        label.font = UIFont.boldSystemFont(ofSize: 40)
        label.textColor = .red
        label.text = "25"
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let getButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.red, for: .normal)
        button.setTitle("Get", for: .normal)
        button.layer.borderWidth = 3
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.layer.borderColor = UIColor.red.cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    let headerStack: UIStackView = {
        let stack = UIStackView()
        stack.layer.masksToBounds = true
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    let titleLabel: CustomInsetLabel = {
        let label = CustomInsetLabel()
        label.setupInsets(top: 10, bottom: 0, left: 20, right: 0)
        label.layer.masksToBounds = true
        label.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .white
        label.text = "Food Title"
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let expandButton: UIButton = {
        let button = UIButton()
        let image = Ionicons.androidOpen.image(30, color: .white)
        button.setImage(image, for: .normal)
        button.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    let listStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.alignment = .center
        stack.distribution = .fillEqually
        return stack
    }()
    let benefitsLabel: CustomInsetLabel = {
        let label = CustomInsetLabel()
        label.setupInsets(top: 10, bottom: 0, left: 0, right: 0)
        label.layer.masksToBounds = true
        label.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .white
        label.text = "Benefits"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let negativesLabel: CustomInsetLabel = {
        let label = CustomInsetLabel()
        label.setupInsets(top: 10, bottom: 0, left: 0, right: 0)
        label.layer.masksToBounds = true
        label.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .white
        label.text = "Harmful"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let exitButton: UIButton = {
        let button = UIButton()
        let image = Ionicons.close.image(30, color: .white)
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = true
        return button
    }()
  
    var bottomConstraint: NSLayoutConstraint?
    var foods: [Food] = []
    var lastFoodFound: Food?
    var isScanning = true
    var filteredFoods: [Food] = []
    var timer: Timer!
    var counter = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        foodList.delegate = self
        foodList.dataSource = self
        
        getButton.addTarget(self, action: #selector(getAction), for: .touchUpInside)
        expandButton.addTarget(self, action: #selector(expandInfo), for: .touchUpInside)
        exitButton.addTarget(self, action: #selector(exitButtonPressed), for: .touchUpInside)
        
        // Set up Camera Session
        let cameraSession = AVCaptureSession()
        cameraSession.sessionPreset = .hd1920x1080;
        
        guard let device = AVCaptureDevice.default(for: .video) else { return }
        guard let input = try? AVCaptureDeviceInput(device: device) else { return }
        cameraSession.addInput(input);
        cameraSession.startRunning();
        
        // Show user the camera on the VC
        let preview = AVCaptureVideoPreviewLayer(session: cameraSession);
        preview.videoGravity = AVLayerVideoGravity.resizeAspectFill;
        view.layer.addSublayer(preview);
        preview.frame = view.frame;
        
        let output = AVCaptureVideoDataOutput();
        output.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"));
        cameraSession.addOutput(output);
        // Do any additional setup after loading the view.
        
        layout()
        
        hideSearchView()
        hideScannerView()
        showInactiveSearchBar()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardDidShow),
            name: NSNotification.Name.UIKeyboardDidShow,
            object: nil
        )
        
        timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(incrementCounter), userInfo: nil, repeats: true)
        navigationItem.backBarButtonItem = UIBarButtonItem.init(title: "", style: .plain, target: nil, action: nil)
        
        loadFoods()
    }
    
    private func loadFoods() {
        
        let doritosBenefits = ["Gluten Free": false, "Heart Healthy": false, "Protein": false, "Low-Carbs": false]
        let doritosDownsides = ["Carcinogenic": true, "Neurotoxins": false, "Cholesterol": true, "Saturated Fats": true]
        let doritosIngredients = ["Corn", "Corn Oil", "Canola Oil", "Sunflower Oil", "Maltodextrin",
                                  "Salt", "Milk", "Cheese Cultures", "Enzymes", "Whey",
                                  "Monosodium Glutamate", "Whey Protein Concentrate", "Buttermilk", "Onion Powder",
                                  "Corn Flour", "Dextrose", "Tomato Powder", "Lactose", "Spices", "Yellow 5",
                                  "Yellow 6", "Red 40", "Lactic Acid", "Citric Acid", "Sugar", "Garlic Powder",
                                  "Red/Green Pepper Powder", "Disodium Inosinate", "disodium Guanylate"]
        let doritos = Food(name: "Doritos", score: 38, benefits: doritosBenefits, negatives: doritosDownsides, ingredients: doritosIngredients)
        
        
        //CINANAMON ROLL
        let cinnamonRollBenefits = ["Gluten Free": false, "Heart Healthy": false, "Protein": false, "Low-Carbs": false]
        let cinnamonRollDownsides = ["Carcinogenic": false, "Neurotoxins": false, "Cholesterol": false, "Saturated Fats": true]
        let cinnamonRollIngredients = ["Flour", "Malted Barley Flour", "Niacin", "Iron",
                                       "Thiamine Mononitrate", "Riboflavin", "Folic Acid", "Water", "Egg", "Butter",
                                       "Palm Oil", "Soybean Oil", "Salt", "Beta Carotene", "Vitamin A Palmitate",
                                       "Brown Sugar", "Sugar", "Yeast", "Cinnamon", "Milk", "Cheese Culture",
                                       "Carob Bean Gum", "Ascorbic Acid", "Honey", "Natural Vanilla Flavor",
                                       "Soybean Oil", "Corn Syrup", "CornStarch", "Agar", "Natural Lemon Flavor"]
        let cinnamonRoll = Food(name: "cinnamon roll", score: 44, benefits: cinnamonRollBenefits, negatives: cinnamonRollDownsides, ingredients: cinnamonRollIngredients)
        
        //CHEETOS
        let cheetosBenefits = ["Gluten Free": false, "Heart Healthy": false, "Protein": false, "Low Carbs": false]
        let cheetosDownsides = ["Carcinogenic": true, "Neurotoxins": false, "Cholesterol": true, "Saturated Fats": true]
        let cheetosIngredients = ["Corn Meal", "Iron", "Niacin", "Thiamine Mononitrate",
                                  "Riboflavin", "FolicAcid", "Corn Oil", "Canola Oil", "Sunflower Oil", "Whey", "Milk", "Cheese Cultures", "Salt", "Maltodextrin", "Whey Protein Concentrate", "Monosodium Glutamate", "Lactic Acid", "Citric Acid", "Yellow 6"]
        let cheetos = Food(name: "Cheetos", score: 38, benefits: cheetosBenefits, negatives: cheetosDownsides, ingredients: cheetosIngredients)
        
        //EVERYTHING BAGAEL
        let everythingBagelBenefits = ["Gluten Free": false, "Heart Healthy": true, "Protein": false, "Low Carbs": false]
        let everythingBagelDownsides = ["Carcinogenic": false, "Neurotoxins": false, "Cholesterol": false, "Saturated Fats": false]
        let everythingBagelIngredients = ["wheatFlour", "maltedBarleyFlour", "niacin", "iron",
                                          "Thiamine Mononitrate", "Riboflavin", "Folic Acid", "Water", "Brown Sugar",
                                          "Sesame Seed", "Poppy Seed", "Salt", "Garlic", "Onion Powder",
                                          "Malted Wheat Flour", "Niacin", "Yeast", "Acerola Extract", "Fungal Enzymes",
                                          "Sorbitan Monostearate", "Ascorbic Acid"]
        let everythingBagel = Food(name: "Everything Bagel", score: 72, benefits: everythingBagelBenefits, negatives: everythingBagelDownsides, ingredients: everythingBagelIngredients)
        
        foods = [doritos, cheetos, cinnamonRoll, everythingBagel]
    }
    
    func showFoodDetailsView(food: Food) {
        let foodDetailsView = FoodDetailsView(food: food, parent: self, getAction: #selector(getAction))
        foodDetailsView.layout()
        foodDetailsView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        self.view.bringSubview(toFront: foodDetailsView)
        exitButton.isHidden = false
        view.bringSubview(toFront: exitButton)
    }
    
    func hideFoodDetailsView() {
        for view in view.subviews {
            if let _ = view as? FoodDetailsView {
                view.removeFromSuperview()
            }
        }
        exitButton.isHidden = true
    }
    
    func hideInactiveSearchBar() {
        isScanning = false
        searchBar.isHidden = true
    }
    
    func showInactiveSearchBar() {
        isScanning = true
        searchBar.isHidden = false
    }
    
    func showScannerView() {
        scoreView.isHidden = false
        headerStack.isHidden = false
        listStack.isHidden = false
        getButton.isHidden = false
    }
    
    func hideScannerView() {
        scoreView.isHidden = true
        listStack.isHidden = true
        headerStack.isHidden = true
        getButton.isHidden = true
    }
    
    func showSearchView() {
        searchBar.showsCancelButton = true
        searchBar.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        searchBar.isHidden = false
        foodList.isHidden = false
    }
    
    func hideSearchView() {
        searchBar.showsCancelButton = false
        searchBar.backgroundColor = .clear
        foodList.isHidden = true
        searchBar.isHidden = true
    }
    
    @objc func expandInfo() {
        hideScannerView()
        hideInactiveSearchBar()
        if let food = lastFoodFound {
            showFoodDetailsView(food: food)
        }
    }
    
    @objc func getAction() {
        
    }
    
    @objc func exitButtonPressed() {
        hideFoodDetailsView()
        showInactiveSearchBar()
    }
    
    @objc
    private func incrementCounter() {
        counter = counter + 1
    }
    private func resetCounter() {
        counter = 0
    }
    
    @objc func keyboardDidShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            guard let bottomContraint = self.bottomConstraint else {
                return
            }
            
            bottomContraint.constant = -keyboardHeight
            UIView.animate(withDuration: 0.5, animations: {
                self.view.layoutIfNeeded()
            })
        }
    }
    
    private func layout() {
        layoutSearchBar()
        layoutScoreView()
        layoutGetButton()
        layoutFoodList()
        layoutDetailsView()
        layoutExitButton()
    }
    
    private func layoutExitButton() {
        view.addSubview(exitButton)
        exitButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        exitButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
    }
    
    private func layoutSearchBar() {
        view.addSubview(searchBar)
        searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        searchBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        searchBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
    }
    
    private func layoutScoreView() {
        view.addSubview(scoreView)
        scoreView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        scoreView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 50).isActive = true
        scoreView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        scoreView.widthAnchor.constraint(equalToConstant: 100).isActive = true
    }
    
    private func layoutGetButton(){
        view.addSubview(getButton)
        getButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        getButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        getButton.heightAnchor.constraint(equalToConstant: 20)
        getButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true
    }
    
    private func layoutDetailsView(){
        headerStack.addArrangedSubview(titleLabel)
        headerStack.addArrangedSubview(expandButton)
        
        listStack.addArrangedSubview(benefitsLabel)
        listStack.addArrangedSubview(negativesLabel)
        
        view.addSubview(headerStack)
        view.addSubview(listStack)
        
        benefitsLabel.topAnchor.constraint(equalTo: listStack.topAnchor).isActive = true
        negativesLabel.topAnchor.constraint(equalTo: listStack.topAnchor).isActive = true
        benefitsLabel.bottomAnchor.constraint(equalTo: listStack.bottomAnchor).isActive = true
        negativesLabel.bottomAnchor.constraint(equalTo: listStack.bottomAnchor).isActive = true
        
        headerStack.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        headerStack.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        listStack.centerXAnchor.constraint(equalTo: headerStack.centerXAnchor).isActive = true
        listStack.widthAnchor.constraint(equalTo: headerStack.widthAnchor).isActive = true
        listStack.topAnchor.constraint(equalTo: headerStack.bottomAnchor).isActive = true
        listStack.bottomAnchor.constraint(equalTo: getButton.topAnchor, constant: -20).isActive = true
        expandButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        benefitsLabel.heightAnchor.constraint(equalTo: negativesLabel.heightAnchor).isActive = true
        listStack.heightAnchor.constraint(greaterThanOrEqualToConstant: 40).isActive = true
    }
    
    private func layoutFoodList() {
        view.addSubview(foodList)
        foodList.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 0).isActive = true
        foodList.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0).isActive = true
        foodList.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0).isActive = true
        bottomConstraint = foodList.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        view.addConstraint(bottomConstraint!)
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        // get the image data
        
            guard let pixelBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
            guard let model = try? VNCoreMLModel(for: FoodID()
                .model) else { return }
            let request = VNCoreMLRequest(model: model) { (finishedReq, err) in
                guard let results = finishedReq.results as? [VNClassificationObservation] else { return }
                
                let predictionNames = results.filter {$0.confidence > 0.9999; }.map { (prediction: VNClassificationObservation) -> String in
                        return "\(prediction.identifier)"
                }
                
                //print(predictionNames)
                
                DispatchQueue.main.async {
                    if predictionNames.count != 0 {
                        self.resetCounter()
                    } else {
                        if self.counter >= 3 {
                            self.hideScannerView()
                        }
                    }
                    
                    if self.isScanning {
                        if predictionNames.count > 0 {
                            let foodName = predictionNames.first!
                            if let food = self.getFoodObject(foodName: foodName) {
                                self.showScannerView()
                                self.titleLabel.text = foodName
                                self.updateScoreAndGet(value: food.score)
                                self.setBenefits(benefits: food.benefits)
                                self.setNegatives(negatives: food.negatives)
                                self.lastFoodFound = food
                            }
                            
                        }
                    }
                }
            }
            try? VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform([request])
    }
    
    private func getFoodObject(foodName: String)-> Food? {
        for food in foods {
            if food.name.lowercased() == foodName.lowercased() {
                return food
            }
        }
        return nil
    }
    
    private func setBenefits(benefits: [String: Bool]) {
        var benefitText = "Benefits\n"
        
        for i in 0...min(benefits.keys.count - 1, 2) {
            benefitText = benefitText + " \(Array(benefits.keys)[i])\n"
        }
        benefitsLabel.text = benefitText
    }
    
    private func setNegatives(negatives: [String: Bool]) {
        var negativesText = "Negatives\n"
        for i in 0...min(negatives.keys.count - 1, 2) {
            negativesText = negativesText + " \(Array(negatives.keys)[i])\n"
        }
        negativesLabel.text = negativesText
    }
        

    private func updateScoreAndGet(value: Int) {
        DispatchQueue.main.async { [unowned self] in
            self.scoreView.text = String(value)
            let color = self.getColor(n: Double(value))
            self.scoreView.textColor = color
            self.getButton.setTitleColor(color, for: .normal)
            self.getButton.layer.borderColor = color.cgColor
        }
    }
    
    private func getColor(n: Double)-> UIColor {
        let R = (255.0 * (100.0 - n)) / 100.0
        let G = (255.0 * n) / 100.0
        let B = 0.0
        
        return UIColor.init(red: CGFloat(R)/255, green: CGFloat(G)/255, blue: CGFloat(B), alpha: 1)
    }

}

// MARK: - SearchBar Data Handler
extension CameraSessionVC: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.hideInactiveSearchBar()
        self.hideScannerView()
        self.showSearchView()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredFoods = foods.filter { (food) -> Bool in
           return food.name.lowercased().contains(searchText.lowercased())
        }
        foodList.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        searchBar.endEditing(true)
        self.hideSearchView()
        self.showInactiveSearchBar()
    }
}


// MARK: - CollectionView Layout
extension CameraSessionVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if (collectionView.restorationIdentifier == "FoodList") {
            let padding: CGFloat = 20
            let cellHeight: CGFloat = 100
            let cellWidth: CGFloat = view.frame.width - padding*2
            return CGSize(width: cellWidth, height: cellHeight)
        }
        else if (collectionView.restorationIdentifier == "InfoCollection") {
            let cellHeight: CGFloat = 20
            let cellWidth: CGFloat = (view.frame.width - 40)
            return CGSize(width: cellWidth, height: cellHeight)
        }
        return CGSize()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
   
}

// MARK: - CollectionView Data Handler
extension CameraSessionVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if collectionView.restorationIdentifier == "InfoCollection" {
            return 3
        } else {
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.restorationIdentifier == "InfoCollection" {
            for view in view.subviews  {
                if let v = view as? FoodDetailsView {
                    if let food = v.food {
                        if section == 0 {
                           return food.ingredients.count
                        }
                        else if section == 1 {
                            return food.benefits.count
                        }
                        else {
                            return food.negatives.count
                        }
                    }
                }
            }
            return 0
        } else {
            return filteredFoods.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if (collectionView.restorationIdentifier == "FoodList") {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FoodCell.id, for: indexPath) as? FoodCell {
                cell.setup(food: filteredFoods[indexPath.row])
                return cell
            }
            return FoodCell()
        }
        else if (collectionView.restorationIdentifier == "InfoCollection") {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InfoCell.id, for: indexPath) as? InfoCell {
                cell.backgroundColor = .red
                for view in view.subviews  {
                    if let v = view as? FoodDetailsView {
                        if let food = v.food {
                            if indexPath.section == 0 {
                                cell.setup(label: food.ingredients[indexPath.row])
                            }
                            else if indexPath.section == 1 {
                                cell.setup(label: Array(food.benefits.keys)[indexPath.row])
                            }
                            else {
                                cell.setup(label: Array(food.negatives.keys)[indexPath.row])
                            }
                        }
                    }
                }
                

                return cell
            }
            return FoodCell()
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // pass the data to the food detail vc
        searchBar.endEditing(true)
        searchBar.text = nil 
        hideSearchView()
        showFoodDetailsView(food: filteredFoods[indexPath.row])
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if collectionView.restorationIdentifier == "InfoCollection" {
            for view in view.subviews  {
                if let v = view as? FoodDetailsView {
                    if let food = v.food {
                        if let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: HeaderView.id, for: indexPath as IndexPath) as? HeaderView {
                            headerView.frame.size.height = 100
                            headerView.setup(label: food.name)
                            return headerView
                        }
                    }
                }
            }
        }
        
        return UICollectionReusableView()
      
    }
}

