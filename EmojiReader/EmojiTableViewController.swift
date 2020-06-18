//
//  EmojiTableViewController.swift
//  EmojiReader
//
//  Created by Egor  on 18.06.2020.
//  Copyright © 2020 Gregor Kramer. All rights reserved.
//

import UIKit

class EmojiTableViewController: UITableViewController {

    var objects = [
    
        Emoji(emoji: "😎", name: "Smile", description: "Smiling", isFavourite: false),
        Emoji(emoji: "🤓", name: "Smile1", description: "Smiling1", isFavourite: false),
        Emoji(emoji: "😁", name: "Smile2", description: "Smiling2", isFavourite: false)
    ]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
         self.navigationItem.leftBarButtonItem = self.editButtonItem
    }

    
    @IBAction func unwindSegue(segue: UIStoryboardSegue) {
        
        guard segue.identifier == "saveButton" else {return}

        let sourceVC = segue.source as! NewEmojiTableViewController
        let emoji = sourceVC.emoji
        
        if let selectedIP = tableView.indexPathForSelectedRow {
            
            objects[selectedIP.row] = emoji
            tableView.reloadRows(at: [selectedIP], with: .automatic)
        } else {
            
            let newIP = IndexPath(row: objects.count, section: 0)
            objects.append(emoji)
            tableView.insertRows(at: [newIP], with: .fade)
        }
  
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard segue.identifier == "editSegue" else { return }
        
        let selectedIndexPath = tableView.indexPathForSelectedRow!
        let editEmoji = objects[selectedIndexPath.row]
        
        let naviVC = segue.destination as! UINavigationController
        let editVC = naviVC.topViewController as! NewEmojiTableViewController
        
        editVC.emoji = editEmoji
        editVC.title = "Edit Your Emoji"
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return objects.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! EmojiTableViewCell

        let object = objects[indexPath.row]
       
        cell.set(object: object)
        
        return cell
    }
    

    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let done = doneAction(at: indexPath)
        let favourite = favouriteAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [done,favourite])
    }
    
    
    func doneAction(at indepPathE: IndexPath) -> UIContextualAction {
        
        let action = UIContextualAction(style: .destructive, title: "done") { (action, view, complition) in
            
            self.objects.remove(at: indepPathE.row)
            self.tableView.deleteRows(at: [indepPathE], with: .automatic)
            complition(true)
        }
        action.backgroundColor = .systemGreen
        action.image = UIImage(systemName: "checkmark.circle")
        
        return action
    }
    
    func favouriteAction(at indexPath:IndexPath) -> UIContextualAction{
        
        var object = objects[indexPath.row]
        
        let action = UIContextualAction(style: .normal, title: "favour") { (action, view, complition) in
            
            object.isFavourite = !object.isFavourite
            self.objects[indexPath.row] = object
            complition(true)
    }
        action.backgroundColor = object.isFavourite ? .systemPurple : .systemGreen
        action.image = UIImage(systemName: "heart")
        
    return action
}

 
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        let movedEmoji = objects.remove(at: sourceIndexPath.row)
        objects.insert(movedEmoji, at: destinationIndexPath.row)
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            objects.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}

