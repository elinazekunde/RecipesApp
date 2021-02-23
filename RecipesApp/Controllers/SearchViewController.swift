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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        handleGetData()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func searchButtonTapped(_ sender: Any) {
        handleGetData()
    }
    
    func handleGetData() {
        if let keyword = keywordLabel.text, keyword != "" {
            jsonUrl += keyword
        }
        
        guard let url = URL(string: jsonUrl) else { return }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-type")
        
        let session = URLSession(configuration: URLSessionConfiguration.default)
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            if let err = error {
                print("error: \(err.localizedDescription)")
            }
            
            guard let data = data else {
                print("Data error!")
                return
            }
            
            do {
                if let dictData = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    //print("dictData", dictData)
                    self.populateData(dictData)
                }
            } catch {
                print("error when converting json")
            }
        }
        task.resume()
    }
    
    func populateData(_ dict: [String: Any]) {
        guard let responseDict = dict["meals"] as? [Gloss.JSON] else { return }
        
        items = [Item].from(jsonArray: responseDict) ?? []
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.keywordLabel.text = ""
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
        
        cell.recipeLabel.text = item.title
        cell.categoryLabel.text = item.category
        cell.areaLabel.text = item.area
        cell.tagLabel.text = item.tags
        
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
        
        navigationController?.pushViewController(vc, animated: true)
    }
}
