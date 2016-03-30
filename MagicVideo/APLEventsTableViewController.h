
/*
     File: APLEventsTableViewController.h
 Abstract: The table view controller responsible for displaying the list of events, supporting additional functionality:
 * Addition of new events;
 * Deletion of existing events using UITableView's tableView:commitEditingStyle:forRowAtIndexPath: method.
 * Editing an event's name.
 
  
 
 */

#import <CoreLocation/CoreLocation.h>

@interface APLEventsTableViewController : UITableViewController <CLLocationManagerDelegate, UITextFieldDelegate>

@property (nonatomic) NSManagedObjectContext *managedObjectContext;	    

@end
