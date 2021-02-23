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
    
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var recipeLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var areaLabel: UILabel!
    @IBOutlet weak var tagLabel: UILabel!
    @IBOutlet weak var instructionsLabel: UITextView!
    @IBOutlet weak var textViewHC: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        recipeLabel.text = titleString
        recipeImageView.image = recipeImage
        categoryLabel.text = categoryString
        areaLabel.text = areaString
        tagLabel.text = tagString
        instructionsLabel.text = instructionsString
        
        textViewHC.constant = self.instructionsLabel.contentSize.height + 30

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
            warningPopup(withTitle: "Error!", withMessage: error.localizedDescription)
        }
    }
    
    func warningPopup(withTitle title: String?, withMessage message: String?) {
        DispatchQueue.main.async {
            let popup = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okButton = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            popup.addAction(okButton)
            
            self.present(popup, animated: true, completion: nil)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
