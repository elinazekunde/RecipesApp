//
//  ShoppingListTableViewController.swift
//  RecipesApp
//
//  Created by Elīna Zekunde on 23/02/2021.
//

import UIKit
import CoreData

class ShoppingListTableViewController: UITableViewController {

    var shoppingList = [ShoppingList]()
    var context: NSManagedObjectContext?

    override func viewDidLoad() {
        super.viewDidLoad()

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        loadData()
    }

    @IBAction func addNewItemTapped(_ sender: Any) {
        addNewItem()
    }
    
    @IBAction func shareButtonTapped(_ sender: Any) {
        let result = sharedData()
        let shareSheetVC = UIActivityViewController(activityItems: [result], applicationActivities: nil)
        
        present(shareSheetVC, animated: true)
    }
    
    private func addNewItem() {
        let alertController = UIAlertController(title: "New Item!", message: "What do you wish to add?", preferredStyle: .alert)
        alertController.addTextField { (textField: UITextField) in
            textField.placeholder = "Enter the name of the item"
            textField.autocapitalizationType = .sentences
            textField.autocorrectionType = .no
        }
        alertController.addTextField { (detailsField: UITextField) in
            detailsField.placeholder = "Enter additional details, e.g., weight"
            detailsField.autocapitalizationType = .sentences
            detailsField.autocorrectionType = .no
        }
        
        let addAction = UIAlertAction(title: "Add", style: .cancel) { (action: UIAlertAction) in
            
            let textField = alertController.textFields?.first
            let detailsField = alertController.textFields?.last
            
            if textField?.text == "" {
                self.warningPopup(withTitle: "Please enter item name", withMessage: nil)
            } else {
                let entity = NSEntityDescription.entity(forEntityName: "ShoppingList", in: self.context!)
                let item = NSManagedObject(entity: entity!, insertInto: self.context)
                item.setValue(textField?.text, forKey: "title")
                item.setValue(detailsField?.text, forKey: "details")
                self.saveData()
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        alertController.addAction(cancelAction)
        alertController.addAction(addAction)
        present(alertController, animated: true)
    }
    
    func sharedData() -> String {
        var resultString = ""

        let request: NSFetchRequest<ShoppingList> = ShoppingList.fetchRequest()
        do {
            let result = try context?.fetch(request)
            shoppingList = result!
        } catch {
            warningPopup(withTitle: "Error occured!", withMessage: error.localizedDescription)
            fatalError(error.localizedDescription)
        }
        
        shoppingList.forEach { item in
            if resultString == "" {
                resultString.append("\(item.value(forKey: "title")!) - \(item.value(forKey: "details")!)")
            } else {
                resultString.append(", \(item.value(forKey: "title")!) - \(item.value(forKey: "details")!)")
            }
        }
        return resultString
    }
    
    func loadData() {
        let request: NSFetchRequest<ShoppingList> = ShoppingList.fetchRequest()
        do {
            let result = try context?.fetch(request)
            shoppingList = result!
        } catch {
            warningPopup(withTitle: "Error occured!", withMessage: error.localizedDescription)
            fatalError(error.localizedDescription)
        }
        tableView.reloadData()
    }
    
    func saveData() {
        do {
            try self.context?.save()
        } catch {
            warningPopup(withTitle: "Error occured!", withMessage: error.localizedDescription)
            fatalError(error.localizedDescription)
        }
        loadData()
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shoppingList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "shoppingCell",for: indexPath)
        let item = shoppingList[indexPath.row]
        cell.textLabel?.text = item.value(forKey: "title") as? String
        cell.detailTextLabel?.text = item.value(forKey: "details") as? String
        cell.accessoryType = item.bought ? .checkmark : .none
        cell.selectionStyle = .none
        return cell
    }

    //MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        shoppingList[indexPath.row].bought = !shoppingList[indexPath.row].bought
        saveData()
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let alert = UIAlertController(title: "Delete.", message: "Are you sure you want to delete this item?", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
                let item = self.shoppingList[indexPath.row]
                
                self.context?.delete(item)
                self.saveData()
            }))
            self.present(alert, animated: true)
        }
    }

    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        let currentItem = shoppingList.remove(at: fromIndexPath.row)
        shoppingList.insert(currentItem, at: to.row)
        saveData()
    }
}
