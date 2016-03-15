//
//  TableViewController.swift
//  MemeMe2.0
//
//  Created by MacbookPRV on 15/01/2016.
//  Copyright © 2016 Pastouret Roger. All rights reserved.
//

import Foundation
import UIKit

class TableViewController: UITableViewController {
    
    
    @IBOutlet weak var buttonEdit: UIBarButtonItem!
    
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        
        let sentmemes = SentMemes.singleton
        if let _ = sentmemes.memeArray {
            buttonEdit.enabled=true
            tableView.reloadData()
        }
        else {
            buttonEdit.enabled=false
        }
        
    }
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        super.tableView(tableView, numberOfRowsInSection: section)
        
        let sentmemes = SentMemes.singleton
        if let _ = sentmemes.memeArray {
            return sentmemes.memeArray.count
        }
        else {
            return 0
        }
        
    }
    
    
    override func setEditing(editing: Bool, animated: Bool) {
        
        super.setEditing(editing, animated: animated)
        tableView.setEditing(editing, animated: animated)
        
    }
    
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        //delete row
        let sentmemes = SentMemes.singleton
        if let _ = sentmemes.memeArray {
            sentmemes.memeArray.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Left)
            if sentmemes.memeArray.count == 0 {
                buttonEdit.title="Edit"
                buttonEdit.enabled=false
                editing = false
            }
        }
        
        
        
    }
    
    
    
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        super.tableView(tableView, cellForRowAtIndexPath: indexPath)
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        let sentmemes = SentMemes.singleton
        let meme = sentmemes.memeArray[indexPath.row]
        cell.imageView?.image=meme.memedImage
        cell.textLabel?.text=meme.textTop + " " + meme.textBottom
        cell.textLabel?.textAlignment=NSTextAlignment.Center
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        return cell
        
    }
    
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let cell = tableView.cellForRowAtIndexPath(indexPath)!
        let controller = UIViewController()
        controller.view = cell.imageView
        controller.view.contentMode = UIViewContentMode.ScaleAspectFit
        navigationController?.pushViewController(controller, animated: true)
        
        
    }
    
    
    @IBAction func ActionEdit(sender: AnyObject) {
        
        
        
        if buttonEdit.title == "Edit" {
            editing=true
            buttonEdit.title="Done"
        }
        else {
            editing=false
            buttonEdit.title="Edit"
        }
        
    }
    
    
    
}