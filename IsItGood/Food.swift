//
//  Food.swift
//  IsItGood
//
//  Created by Yosvani Lopez on 7/28/18.
//  Copyright © 2018 Yosvani Lopez. All rights reserved.
//

import Foundation
import UIKit

class Food: NSObject, Decodable {
    let name: String!
    let score: Int!
    let ingredients: [String]!
    let benefits: [String: Bool]!
    let negatives: [String: Bool]!
    
    init(name: String, score: Int, benefits: [String: Bool], negatives: [String: Bool], ingredients: [String]) {
        self.name = name
        self.score = score
        self.ingredients = ingredients
        self.benefits = benefits
        self.negatives = negatives
    }
}
