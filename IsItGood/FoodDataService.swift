//
//  FoodDataService.swift
//  IsItGood
//
//  Created by Yosvani Lopez on 7/29/18.
//  Copyright © 2018 Yosvani Lopez. All rights reserved.
//

import Foundation

//class FoodDataService {
//    static let shared = FoodDataService()
//    
//    
//    func getFoodList(complete: ([Ingredient])->()) {
//        if let path = Bundle.main.path(forResource: "IngredientDatabase", ofType: "json") {
//            do {
//                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
//                guard let foodList = try? JSONDecoder().decode([String: [String: [String: Int]]].self, from: data) else {
//                    print("Error: Couldn't decode data into object)
//                    return
//                }
//                
//                
//            } catch {
//                // handle error
//            }
//        }
//    }
//    
//
//
//}
