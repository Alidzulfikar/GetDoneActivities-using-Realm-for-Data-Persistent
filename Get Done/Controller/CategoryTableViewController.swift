//
//  ViewController.swift
//  Get Done
//
//  Created by PHANTOM on 26/04/20.
//  Copyright © 2020 Dzulfikar Ali. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework
import SwipeCellKit

class CategoryTableViewController: SwipeCellTableViewController {
    
    let realm = try! Realm()
    var categories: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        loadCategory()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let navBarBgColor = UIColor(hexString: "#9c88ff") {
            updateNavBar(navBarBgColor)
        }
    }
    
    // MARK: - Tableview Data Source Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let category = categories?[indexPath.row]{
            
            cell.textLabel?.text = category.name
            
            if let categoryColor = UIColor(hexString: category.colour) {
                
                cell.backgroundColor = categoryColor
                
                cell.textLabel?.textColor = ContrastColorOf(categoryColor, returnFlat: true)
                
            }
        } else {
            cell.textLabel?.text = "No Categories Added Yet"
        }
        
        
        return cell
    }
    
    // MARK: - Manipulation Data Realm
    func saveCategory(category: Category){
        
        do {
            try realm.write{
                realm.add(category)
            }
        } catch {
            print("Error in saving catgeory data \(error).")
        }
        
        tableView.reloadData()
    }
    
    func loadCategory(){
        
        categories = realm.objects(Category.self)
        
        tableView.reloadData()
    }
    
    // MARK: - Delete Data From Swipe Cell
    override func updateModuls(at indexPath: IndexPath) {
        if let category = self.categories? [indexPath.row]{
            do{
                try self.realm.write{
                    self.realm.delete(category)
                }
            } catch {
                print("Error deleting category data \(error).")
            }
        }
    }
    
    // MARK: - Table View Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ItemTableViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
    // MARK: - Add Category
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let newCategory = Category()
            newCategory.name = textField.text!
            newCategory.colour = UIColor.randomFlat().hexValue()
            
            self.saveCategory(category: newCategory)
        }
        
        alert.addTextField { (alertTF) in
            alertTF.placeholder = "Create new category"
            textField = alertTF
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
}

