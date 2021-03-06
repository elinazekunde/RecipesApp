//
//  BookmarksTableViewController.swift
//  RecipesApp
//
//  Created by Elīna Zekunde on 23/02/2021.
//

import UIKit
import CoreData

class BookmarksTableViewController: UITableViewController {

    var bookmarks = [Bookmarks]()
    var context: NSManagedObjectContext?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
        
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        loadData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        loadData()
    }
    
    func loadData() {
        let request: NSFetchRequest<Bookmarks> = Bookmarks.fetchRequest()
        
        do {
            let result = try context?.fetch(request)
            bookmarks = result!
        } catch {
            warningPopup(withTitle: "Error!", withMessage: error.localizedDescription)
        }
        tableView.reloadData()
    }
    
    func saveData() {
        do {
            try context?.save()
        } catch {
            warningPopup(withTitle: "Error!", withMessage: error.localizedDescription)
        }
        loadData()
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookmarks.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "savedRecipeCell", for: indexPath) as? RecipeTableViewCell else {
            return UITableViewCell()
        }
        
        let bookmark = bookmarks[indexPath.row]
        
        if bookmark.image != nil {
            if let image = UIImage(data: bookmark.image!) {
                cell.imageView!.image = image
            }
        } else {
            cell.imageView!.image = nil
        }
        
        cell.recipeLabel.text = bookmark.recipeTitle
        cell.categoryLabel.text = bookmark.category
        cell.areaLabel.text = bookmark.area
        cell.tagLabel.text = bookmark.tags
        
        return cell
    }

    // MARK: - Table view Delegate
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }


    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let alert = UIAlertController(title: "Delete", message: "Are you sure to delete?", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
                let bookmark = self.bookmarks[indexPath.row]
                
                self.context?.delete(bookmark)
                self.saveData()
            }))
            self.present(alert, animated: true)
        }
    }

    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        let currentItem = bookmarks.remove(at: fromIndexPath.row)
        bookmarks.insert(currentItem, at: to.row)
        saveData()
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        guard let vc = storyboard.instantiateViewController(identifier: "WebViewController") as? WebViewController else {
            return
        }
        
        vc.url = bookmarks[indexPath.row].url!
        
        navigationController?.pushViewController(vc, animated: true)
    }
}
