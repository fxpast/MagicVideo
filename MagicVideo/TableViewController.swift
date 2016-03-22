

import Foundation
import UIKit

class TableViewController: UITableViewController {
    
    
    @IBOutlet weak var buttonEdit: UIBarButtonItem!
    
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        
        let savvideo = SavVideo.singleton()
        let tableau = savvideo.TableauVideo as Array
        if tableau.count > 0
        {
            buttonEdit.enabled=true
            tableView.reloadData()
        }
        else {
            buttonEdit.enabled=false
        }
        
        
        
    }
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        super.tableView(tableView, numberOfRowsInSection: section)
                
        let savvideo = SavVideo.singleton()
        let tableau = savvideo.TableauVideo as Array
        if tableau.count > 0
        {
            return  tableau.count
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
        let savvideo = SavVideo.singleton()
        var tableau = savvideo.TableauVideo as Array
        
         if tableau.count > 0 {
            tableau.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Left)
        }
        
        if tableau.count == 0 {
            buttonEdit.title="Edit"
            buttonEdit.enabled=false
            editing = false
        }
        
        
        
    }
    
    
    
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        super.tableView(tableView, cellForRowAtIndexPath: indexPath)
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        let savvideo = SavVideo.singleton()
        let tableau = savvideo.TableauVideo as Array
        
        let modelvideo = tableau[indexPath.row] as! ModelVideo
        
        cell.imageView?.image=modelvideo.imageVideo
        cell.textLabel?.text=modelvideo.adresseVideo.absoluteString
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