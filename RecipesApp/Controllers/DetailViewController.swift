//
//  DetailViewController.swift
//  RecipesApp
//
//  Created by Elīna Zekunde on 23/02/2021.
//

import UIKit
import CoreData

class DetailViewController: UIViewController {

    var bookmarks = [Bookmarks]()
    var context: NSManagedObjectContext?
    
    var titleString = String()
    var recipeImage = UIImage()
    var categoryString = String()
    var areaString = String()
    var tagString = String()
    var instructionsString = String()
    var urlString = String()
    var ingr1Str = String()
    var ingr2Str = String()
    var ingr3Str = String()
    var ingr4Str = String()
    var ingr5Str = String()
    var ingr6Str = String()
    var ingr7Str = String()
    var ingr8Str = String()
    var ingr9Str = String()
    var ingr10Str = String()
    var measure1Str = String()
    var measure2Str = String()
    var measure3Str = String()
    var measure4Str = String()
    var measure5Str = String()
    var measure6Str = String()
    var measure7Str = String()
    var measure8Str = String()
    var measure9Str = String()
    var measure10Str = String()
    
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var recipeLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var areaLabel: UILabel!
    @IBOutlet weak var tagLabel: UILabel!
    @IBOutlet weak var instructionsLabel: UITextView!
    @IBOutlet weak var ingr1: UILabel!
    @IBOutlet weak var ingr2: UILabel!
    @IBOutlet weak var ingr3: UILabel!
    @IBOutlet weak var ingr4: UILabel!
    @IBOutlet weak var ingr5: UILabel!
    @IBOutlet weak var ingr6: UILabel!
    @IBOutlet weak var ingr7: UILabel!
    @IBOutlet weak var ingr8: UILabel!
    @IBOutlet weak var ingr9: UILabel!
    @IBOutlet weak var ingr10: UILabel!
    @IBOutlet weak var measure1: UILabel!
    @IBOutlet weak var measure2: UILabel!
    @IBOutlet weak var measure3: UILabel!
    @IBOutlet weak var measure4: UILabel!
    @IBOutlet weak var measure5: UILabel!
    @IBOutlet weak var measure6: UILabel!
    @IBOutlet weak var measure7: UILabel!
    @IBOutlet weak var measure8: UILabel!
    @IBOutlet weak var measure9: UILabel!
    @IBOutlet weak var measure10: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        recipeLabel.text = titleString
        recipeImageView.image = recipeImage
        categoryLabel.text = categoryString
        areaLabel.text = areaString
        tagLabel.text = tagString
        instructionsLabel.text = instructionsString
        ingr1.text = ingr1Str
        ingr2.text = ingr2Str
        ingr3.text = ingr3Str
        ingr4.text = ingr4Str
        ingr5.text = ingr5Str
        ingr6.text = ingr6Str
        ingr7.text = ingr7Str
        ingr8.text = ingr8Str
        ingr9.text = ingr9Str
        ingr10.text = ingr10Str
        measure1.text = measure1Str
        measure2.text = measure2Str
        measure3.text = measure3Str
        measure4.text = measure4Str
        measure5.text = measure5Str
        measure6.text = measure6Str
        measure7.text = measure7Str
        measure8.text = measure8Str
        measure9.text = measure9Str
        measure10.text = measure10Str
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
    }
    
    @IBAction func openRecipePressed(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        guard let vc = storyboard.instantiateViewController(identifier: "WebViewController") as? WebViewController else {
            return
        }
        
        vc.url = urlString
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        let newBookmark = Bookmarks(context: self.context!)
        newBookmark.recipeTitle = titleString
        newBookmark.category = categoryString
        newBookmark.area = areaString
        newBookmark.tags = tagString
        newBookmark.url = urlString
        
        guard let imageData: Data = (recipeImage.pngData()) else { return }
        
        if !imageData.isEmpty {
            newBookmark.image = imageData
        }
        
        self.bookmarks.append(newBookmark)
        saveData()
        
        warningPopup(withTitle: "Saved!", withMessage: nil)
    }
    
    func saveData() {
        do {
            try context?.save()
        } catch {
            warningPopup(withTitle: "Error occured!", withMessage: error.localizedDescription)
        }
    }
}
