
/*
 File: APLEventsTableViewController.m
 Abstract: The table view controller responsible for displaying the list of events, supporting additional functionality:
 * Addition of new events;
 * Deletion of existing events using UITableView's tableView:commitEditingStyle:forRowAtIndexPath: method.
 * Editing an event's name.
 
 
 */

#import <CoreData/CoreData.h>
#import "SavVideo.h"

#import "APLEventsTableViewController.h"
#import "APLEventTableViewCell.h"
#import "APLTagSelectionController.h"

#import "APLEvent.h"
#import "APLTag.h"
#import "DataSettings.h"


@interface APLEventsTableViewController ()
{
    SavVideo *wsavvideo;
    DataSettings *WVarPermnt;
    
}

@property (nonatomic) CLLocationManager *locationManager;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *addButton;

@end



@implementation APLEventsTableViewController


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Configure the add and edit buttons.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    
    /*
     Reload the table view if the locale changes -- look at APLEventTableViewCell.m to see how the table view cells are redisplayed.
     */
    __weak UITableViewController *weakSelf = self;
    [[NSNotificationCenter defaultCenter] addObserverForName:NSCurrentLocaleDidChangeNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        
        [weakSelf.tableView reloadData];
    }];
    
    wsavvideo = [SavVideo singleton];
    WVarPermnt = [DataSettings singleton];
    
    if (WVarPermnt.openURL.length>0) {
        
         wsavvideo.url = [NSURL URLWithString:WVarPermnt.openURL];
        [[NSNotificationCenter defaultCenter]addObserver:self
                                                selector:@selector(AffichePlayer)
                                                    name:UIApplicationDidBecomeActiveNotification
                                                  object:nil];
       
        [self AffichePlayer];
        
        
    }
    
    [UIApplication sharedApplication].statusBarHidden=false;
    
}

-(void) ChargeBaseDeDonnee{
    
    /*
     Fetch existing events.
     Create a fetch request for the Event entity; add a sort descriptor; then execute the fetch.
     */
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"APLEvent"];
    [request setFetchBatchSize:20];
    
    // Order the events by creation date, most recent first.
    NSSortDescriptor *sortTag = [[NSSortDescriptor alloc] initWithKey:@"tag" ascending:YES];
    NSSortDescriptor *sortName = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSArray *sortDescriptors = @[sortTag, sortName];
    [request setSortDescriptors:sortDescriptors];
    
    // Execute the fetch.
    NSError *error;
    NSArray *fetchResults = [self.managedObjectContext executeFetchRequest:request error:&error];
    if (fetchResults == nil) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    // Set eventsArray events array to a mutable copy of the fetch results.
    [wsavvideo setEventsArray:[fetchResults mutableCopy]];
    
    
    

}

- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    
    [self ChargeBaseDeDonnee];
    [self.tableView reloadData];

    
}

-(void) viewDidAppear:(BOOL)animated{
    
    
    if (wsavvideo.addVideo) {
        wsavvideo.addVideo = false;
        [self addEvent];
    }

    
}


- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.locationManager = nil;
}


-(void) AffichePlayer{
    
    if (wsavvideo.eventsArray.count>0) {
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"PlayerSimpleViewController"];
        [self.navigationController presentViewController:controller animated:NO completion:nil];
        
    }
    else WVarPermnt.openURL = @"";
    
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - Table view data source methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // There is only one section.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // There are as many rows as there are obects in the events array.
    return [wsavvideo.eventsArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"EventTableViewCell";
    
    APLEventTableViewCell *cell = (APLEventTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.delegate = self;
    
    // Get the event corresponding to the current index path and configure the table view cell.
    APLEvent *event = (APLEvent *)wsavvideo.eventsArray[indexPath.row];
    [cell configureWithEvent:event];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
  
    APLEvent *event = (APLEvent *)wsavvideo.eventsArray[indexPath.row];
    wsavvideo.url = [NSURL URLWithString:event.adresseVideo];
    WVarPermnt.openURL = event.adresseVideo;
    [self AffichePlayer];
    
}


#pragma mark - Editing

/*
 Handle deletion of an event.
 */
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        // Ensure that if the user is editing a name field then the change is committed before deleting a row -- this ensures that changes are made to the correct event object.
        [tableView endEditing:YES];
        
        // Delete the managed object at the given index path.
        NSManagedObject *eventToDelete = (wsavvideo.eventsArray)[indexPath.row];
        [self.managedObjectContext deleteObject:eventToDelete];
        
        // Update the array and table view.
        [wsavvideo.eventsArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        // Commit the change.
        NSError *error;
        if (![self.managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}


- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    self.navigationItem.rightBarButtonItem.enabled = !editing;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"EditTags"]) {
        
        APLEventTableViewCell *cell = (APLEventTableViewCell *)sender;
        
        [cell endEditing:YES];
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        
        APLTagSelectionController *tagSelectionController = [segue destinationViewController];
        tagSelectionController.event = (wsavvideo.eventsArray)[indexPath.row];
    }
}


#pragma mark - Add an event

/*
 Add an event.
 */
- (void)addEvent
{
    
    /*
     Create a new instance of the Event entity.
     */
    APLEvent *event = (APLEvent *)[NSEntityDescription insertNewObjectForEntityForName:@"APLEvent" inManagedObjectContext:self.managedObjectContext];
    
    // Configure the new event with information from the location.
    event.creationDate = [NSDate date];
    event.imagevideo = UIImageJPEGRepresentation(wsavvideo.image, 1.0f);
    event.imagevideo = UIImagePNGRepresentation(wsavvideo.image);
    event.adresseVideo = wsavvideo.url.absoluteString;
    
    /*
     Because this is a new event, and events are displayed with most recent events at the top of the list, add the new event to the beginning of the events array, then:
     * Add a new row to the table view
     * Scroll to make the row visible
     * Start editing the name field
     */
    [wsavvideo.eventsArray insertObject:event atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
    [self setEditing:YES animated:YES];
    APLEventTableViewCell *cell = (APLEventTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    [cell makeNameFieldFirstResponder];
    
    /*
     Don't save yet -- the name is not optional:
     * The user should add a name before the event is saved.
     * If the user doesn't add a name, it will be set to @"" when they press Done.
     */
}


#pragma mark - Editing text fields

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    CGPoint point = [textField center];
    point = [self.tableView convertPoint:point fromView:textField];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:point];
    
    APLEvent *event = (wsavvideo.eventsArray)[indexPath.row];
    event.name = textField.text;
    
    // Commit the change.
    NSError *error;
    if (![self.managedObjectContext save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return YES;
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    /*
     Ensure that a text field for a row for a newly-inserted object is disabled when the user finishes editing.
     */
    textField.enabled = self.editing;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


@end

