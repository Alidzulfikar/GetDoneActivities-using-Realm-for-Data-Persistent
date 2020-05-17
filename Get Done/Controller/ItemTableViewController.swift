//
//  ItemTableViewController.swift
//  Get Done
//
//  Created by PHANTOM on 26/04/20.
//  Copyright © 2020 Dzulfikar Ali. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework


class ItemTableViewController: SwipeCellTableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    var items: Results<Item>?
    
    let realm = try! Realm()
    
    var selectedCategory: Category? {
        didSet{
            loadItems()
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let safeCategory = selectedCategory {
            
            title = safeCategory.name
            
            if let color = UIColor(hexString: safeCategory.colour) {
                updateNavBar(color)
                
                searchBar.barTintColor = color
                searchBar.searchTextField.backgroundColor = FlatWhite()
            }
        }
    }
    
    // MARK: - Tableview Data Source Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = items?[indexPath.row]{
            
            cell.textLabel?.text = item.title
            
            cell.accessoryType = item.done == true ? .checkmark : .none
            
            if let hexColour = UIColor(hexString: selectedCategory!.colour)?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(items!.count)) {
                
                cell.backgroundColor = hexColour
                
                cell.textLabel?.textColor = ContrastColorOf(hexColour, returnFlat: true)
                
            }
            
        }
        return cell
    }
    
    // MARK: - Realm Manipulation Data
    func loadItems(){
        
        items = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
    }
    
    // MARK: - Tableview Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = items?[indexPath.row]{
            
            do{
                try realm.write{
                    item.done = !item.done
                }
            } catch {
                print("Error update done")
            }
        }
        
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Add Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add Items", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write{
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print("Error saving items \(error).")
                }
            }
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTF) in
            alertTF.placeholder = "Create new item"
            textField = alertTF
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
}

extension ItemTableViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        items = items?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            
            loadItems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
    }
    
}
