//
//  Item.swift
//  RecipesApp
//
//  Created by Elīna Zekunde on 22/02/2021.
//

import Foundation
import Gloss
import UIKit

class Item: JSONDecodable {
    var title: String
    var category: String
    var area: String
    var tags: String
    var instructions: String
    var url: String
    var imageUrl: String
    var image: UIImage?
    var ingr1: String
    var ingr2: String
    var ingr3: String
    var ingr4: String
    var ingr5: String
    var ingr6: String
    var ingr7: String
    var ingr8: String
    var ingr9: String
    var ingr10: String
    var measure1: String
    var measure2: String
    var measure3: String
    var measure4: String
    var measure5: String
    var measure6: String
    var measure7: String
    var measure8: String
    var measure9: String
    var measure10: String
    
    required init?(json: JSON) {
        self.title = "strMeal" <~~ json ?? ""
        self.category = "strCategory" <~~ json ?? "Unknown"
        self.area = "strArea" <~~ json ?? "Unknown"
        self.tags = "strTags" <~~ json ?? "-"
        self.instructions = "strInstructions" <~~ json ?? ""
        self.url = "strSource" <~~ json ?? ""
        self.imageUrl = "strMealThumb" <~~ json ?? ""
        self.ingr1 = "strIngredient1" <~~ json ?? ""
        self.ingr2 = "strIngredient2" <~~ json ?? ""
        self.ingr3 = "strIngredient3" <~~ json ?? ""
        self.ingr4 = "strIngredient4" <~~ json ?? ""
        self.ingr5 = "strIngredient5" <~~ json ?? ""
        self.ingr6 = "strIngredient6" <~~ json ?? ""
        self.ingr7 = "strIngredient7" <~~ json ?? ""
        self.ingr8 = "strIngredient8" <~~ json ?? ""
        self.ingr9 = "strIngredient9" <~~ json ?? ""
        self.ingr10 = "strIngredient10" <~~ json ?? ""
        self.measure1 = "strMeasure1" <~~ json ?? ""
        self.measure2 = "strMeasure2" <~~ json ?? ""
        self.measure3 = "strMeasure3" <~~ json ?? ""
        self.measure4 = "strMeasure4" <~~ json ?? ""
        self.measure5 = "strMeasure5" <~~ json ?? ""
        self.measure6 = "strMeasure6" <~~ json ?? ""
        self.measure7 = "strMeasure7" <~~ json ?? ""
        self.measure8 = "strMeasure8" <~~ json ?? ""
        self.measure9 = "strMeasure9" <~~ json ?? ""
        self.measure10 = "strMeasure10" <~~ json ?? ""
          
        DispatchQueue.main.async {
            self.image = self.loadImage()
        }
    }
    
    private func loadImage() -> UIImage? {
        var returnImage: UIImage?
        
        guard let url = URL(string: imageUrl) else {
            return returnImage
        }
        
        if let data = try? Data(contentsOf: url) {
            if let image = UIImage(data: data) {
                returnImage = image
            }
        }
        
        return returnImage
    }
}
