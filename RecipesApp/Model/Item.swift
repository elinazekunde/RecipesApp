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
    
    required init?(json: JSON) {
        self.title = "strMeal" <~~ json ?? ""
        self.category = "strCategory" <~~ json ?? "Unknown"
        self.area = "strArea" <~~ json ?? "Unknown"
        self.tags = "strTags" <~~ json ?? "-"
        self.instructions = "strInstructions" <~~ json ?? ""
        self.url = "strSource" <~~ json ?? ""
        self.imageUrl = "strMealThumb" <~~ json ?? ""
          
        print("KS JSON", json)
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
