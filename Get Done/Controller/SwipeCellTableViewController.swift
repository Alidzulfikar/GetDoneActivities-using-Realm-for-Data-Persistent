//
//  SwipeCellTableViewController.swift
//  Get Done
//
//  Created by PHANTOM on 26/04/20.
//  Copyright © 2020 Dzulfikar Ali. All rights reserved.
//

import UIKit
import SwipeCellKit
import ChameleonFramework

class SwipeCellTableViewController: UITableViewController, SwipeTableViewCellDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorStyle = .none
        tableView.rowHeight = 80.0
       
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
        
        cell.delegate = self
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }

        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            
            self.updateModuls(at: indexPath )
        }

        // customize the action appearance
        deleteAction.image = UIImage(named: "delete-icon")

        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        return options
    }
    
    func updateModuls(at indexPath: IndexPath) {
        
    }
    
    func updateNavBar(_ backgroundColour: UIColor){
        
        guard let navBar = navigationController?.navigationBar else {fatalError("Navigation Controller Does not Exists.")}
        
        let navBarBgColour = ContrastColorOf(backgroundColour, returnFlat: true)
        
         // Small title colors: (also shown when large title collapses by scrolling down)
        navBar.barTintColor = backgroundColour
        navBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: navBarBgColour]
        
        // Large title colors:
        navBar.backgroundColor = backgroundColour
        navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: navBarBgColour]
        
        // Color the back button and icons: (both small and large title)
        navBar.tintColor = navBarBgColour
        
    }

    

}
