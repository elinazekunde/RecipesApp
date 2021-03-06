//
//  SearchViewController.swift
//  RecipesApp
//
//  Created by Elīna Zekunde on 22/02/2021.
//

import UIKit
import Gloss

class SearchViewController: UIViewController {

    var items: [Item] = []
    var jsonUrl = "https://www.themealdb.com/api/json/v1/1/search.php?s="
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var keywordLabel: UITextField!
    @IBOutlet weak var searchButton: BounceButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchButton.layer.cornerRadius = 10
        keywordLabel.layer.borderWidth = 1
        keywordLabel.layer.borderColor = UIColor.systemBlue.cgColor
        keywordLabel.layer.cornerRadius = 15
    }
    
    @IBAction func searchButtonTapped(_ sender: Any) {
        handleGetData()
        showSpinner()
        view.endEditing(true)
    }
    
    func handleGetData() {
        
        if let keyword = keywordLabel.text, keyword != "" {
            jsonUrl += keyword
            
            guard let url = URL(string: jsonUrl) else { return }
            
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "GET"
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-type")
            
            let session = URLSession(configuration: URLSessionConfiguration.default)
            let task = session.dataTask(with: urlRequest) { (data, response, error) in
                if let err = error {
                    self.warningPopup(withTitle: "Error occured!", withMessage: err.localizedDescription)
                }
                
                guard let data = data else {
                    self.warningPopup(withTitle: "Error occured!", withMessage: error?.localizedDescription)
                    return
                }
                
                do {
                    if let dictData = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        self.populateData(dictData)
                    }
                } catch {
                    self.warningPopup(withTitle: "Error occured!", withMessage: error.localizedDescription)
                    print("error when converting json")
                }
            }
            task.resume()
        } else {
            warningPopup(withTitle: "Please enter search details!", withMessage: nil)
        }
    }
    
    fileprivate var aView: UIView?
    
    func showSpinner() {
        aView = UIView(frame: self.view.bounds)
        aView?.backgroundColor = .clear
        
        let ai = UIActivityIndicatorView(style: .large)
        ai.center = aView!.center
        ai.startAnimating()
        aView?.addSubview(ai)
        self.view.addSubview(aView!)
        
        Timer.scheduledTimer(withTimeInterval: 15.0, repeats: false) { t in
            self.removeSpinner()
        }
    }
    
    func removeSpinner() {
        aView?.removeFromSuperview()
        aView = nil
    }
    
    func populateData(_ dict: [String: Any]) {
        guard let responseDict = dict["meals"] as? [Gloss.JSON] else { return }
        
        items = [Item].from(jsonArray: responseDict) ?? []
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.keywordLabel.text = ""
            self.jsonUrl = "https://www.themealdb.com/api/json/v1/1/search.php?s="
            self.removeSpinner()
        }
    }
}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "recipeCell", for: indexPath) as? RecipeTableViewCell else {
            return UITableViewCell()
        }
        
        let item = items[indexPath.row]
        
        if let image = item.image {
            cell.imageView!.image = image
        }
        cell.recipeLabel.layer.borderWidth = 1
        cell.recipeLabel.layer.borderColor = UIColor.systemBlue.cgColor
        cell.recipeLabel.text = item.title
        cell.categoryLabel.text = item.category
        cell.areaLabel.text = item.area
        cell.tagLabel.text = item.tags
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        guard let vc = storyboard.instantiateViewController(identifier: "DetailViewController") as? DetailViewController else {
            return
        }

        vc.titleString = items[indexPath.row].title
        vc.recipeImage = items[indexPath.row].image!
        vc.categoryString = items[indexPath.row].category
        vc.areaString = items[indexPath.row].area
        vc.tagString = items[indexPath.row].tags
        vc.instructionsString = items[indexPath.row].instructions
        vc.urlString = items[indexPath.row].url
        vc.ingr1Str = items[indexPath.row].ingr1
        vc.ingr2Str = items[indexPath.row].ingr2
        vc.ingr3Str = items[indexPath.row].ingr3
        vc.ingr4Str = items[indexPath.row].ingr4
        vc.ingr5Str = items[indexPath.row].ingr5
        vc.ingr6Str = items[indexPath.row].ingr6
        vc.ingr7Str = items[indexPath.row].ingr7
        vc.ingr8Str = items[indexPath.row].ingr8
        vc.ingr9Str = items[indexPath.row].ingr9
        vc.ingr10Str = items[indexPath.row].ingr10
        vc.measure1Str = items[indexPath.row].measure1
        vc.measure2Str = items[indexPath.row].measure2
        vc.measure3Str = items[indexPath.row].measure3
        vc.measure4Str = items[indexPath.row].measure4
        vc.measure5Str = items[indexPath.row].measure5
        vc.measure6Str = items[indexPath.row].measure6
        vc.measure7Str = items[indexPath.row].measure7
        vc.measure8Str = items[indexPath.row].measure8
        vc.measure9Str = items[indexPath.row].measure9
        vc.measure10Str = items[indexPath.row].measure10
        
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension UIViewController {
    func warningPopup(withTitle title: String?, withMessage message: String?) {
        DispatchQueue.main.async {
            let popup = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okButton = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            popup.addAction(okButton)
            
            self.present(popup, animated: true, completion: nil)
        }
    }
}
