//
//  TableViewController.m
//  MagicVideo
//
//  Created by MacbookPRV on 21/03/2016.
//  Copyright © 2016 Pastouret Roger. All rights reserved.
//

#import "TableViewController.h"
#import "SavVideo.h"
#import "ModelVideo.h"
#import "PlayerSimpleViewController.h"
#import "APLCoreDataStackManager.h"
#import "DataSettings.h"

@import CoreData;


@interface TableViewController () <NSFetchedResultsControllerDelegate>
{
    
    SavVideo *wSavvideo;
    DataSettings *WVarPermnt;
    ModelVideo *Wmodel;
    NSTimer *Wtimer;

    
}

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;


@property (weak, nonatomic) IBOutlet UIBarButtonItem *buttonEdit;


@end


@implementation TableViewController


-(void) viewDidLoad {
    
    [super viewDidLoad];
    wSavvideo = [SavVideo singleton];
    WVarPermnt = [DataSettings singleton];
    Wmodel = [[ModelVideo alloc] init];
    
}

-(void) viewWillAppear:(BOOL)animated {
    
    
    [super viewWillAppear:animated];
    
    
   if (wSavvideo.addVideo)
    {
        ModelVideo *model = [[ModelVideo alloc] init];
        model.adresseVideo = wSavvideo.url.absoluteString;
        model.imageVideo = wSavvideo.image;
        model.id_groupe = wSavvideo.id_categ;
        model.nom_groupe = wSavvideo.categorie;
        model.titre = wSavvideo.titre;
        wSavvideo.addVideo = false;
        [self addVideoToPersistentStore:model];
        self.buttonEdit.enabled=true;
        [self.tableView reloadData];
        
    }
    else {
        self.buttonEdit.enabled=false;
    }
    
    
    
    if (wSavvideo.updatVideo)
    {
        ModelVideo *model = [[ModelVideo alloc] init];
        model.adresseVideo = wSavvideo.url.absoluteString;
        model.imageVideo = wSavvideo.image;
        model.id_groupe = wSavvideo.id_categ;
        model.nom_groupe = wSavvideo.categorie;
        model.titre = wSavvideo.titre;
        wSavvideo.updatVideo = false;
        [self UpdateVideoToPersistentStore:Wmodel New:model];
        self.buttonEdit.enabled=true;
        [self.tableView reloadData];
        
    }
    else {
        self.buttonEdit.enabled=false;
    }
    
    
}



-(void) AfficheDiffere {
    
    
    if (wSavvideo.updatVideo) {
        [self viewWillAppear:true];
    }
    
    
}

-(void) viewDidAppear:(BOOL)animated{
    
    
    
    [super viewDidAppear:animated];
    
    
    if (WVarPermnt.openURL.length>0) {
        
        wSavvideo.url = [NSURL URLWithString:WVarPermnt.openURL];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"PlayerSimpleViewController"];
        [self.navigationController presentViewController:controller animated:NO completion:nil];
        
    }
        
}

- (IBAction)ActionEdit:(id)sender {
    
    
    if ([self.buttonEdit.title  isEqual: @"Edit"]) {
        self.editing=true;
        self.buttonEdit.title=@"Done";
    }
    else {
        self.editing=false;
        self.buttonEdit.title=@"Edit";
    }

}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    
  
    return self.fetchedResultsController.sections.count;
}


-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    [super tableView:tableView numberOfRowsInSection:section];


    
    NSInteger numberOfRows = 0;
    
    if ([[self.fetchedResultsController sections] count] > 0) {
        id <NSFetchedResultsSectionInfo> sectionInfo = self.fetchedResultsController.sections[section];
        numberOfRows = [sectionInfo numberOfObjects];
    }
    
    return numberOfRows;

}


-(void) setEditing:(BOOL)editing animated:(BOOL)animated{
    
    [super setEditing:editing animated:animated];
    
    [self.tableView setEditing:editing animated:animated];
    
}




- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.fetchedResultsController.sections.count>0) {
        
        ModelVideo *model = [self.fetchedResultsController objectAtIndexPath:indexPath];
        [self deleteVideoToPersistentStore:model];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        
    }

    
    if (self.fetchedResultsController.sections.count==0) {
        
        self.buttonEdit.title=@"Edit";
        self.editing = false;
        self.buttonEdit.enabled = false;
        
    }

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
      
        
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    Wmodel = [self.fetchedResultsController objectAtIndexPath:indexPath];
   
    cell.imageView.image = Wmodel.imageVideo;
    cell.textLabel.text = [NSString stringWithFormat:@"%@%@%@", Wmodel.titre , @" " , Wmodel.nom_groupe] ;
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.accessoryType = UITableViewCellAccessoryNone;
    return cell;
    
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    Wmodel = [self.fetchedResultsController objectAtIndexPath:indexPath];
    wSavvideo.url = [NSURL URLWithString:Wmodel.adresseVideo] ;
    
    if (self.editing) {
   
        wSavvideo.titre=Wmodel.titre;
        wSavvideo.id_categ = Wmodel.id_groupe;
        wSavvideo.categorie = Wmodel.nom_groupe;
        wSavvideo.image = Wmodel.imageVideo;
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"DetailViewController"];
        [self.navigationController presentViewController:controller animated:NO completion:nil];
        
         Wtimer = [NSTimer scheduledTimerWithTimeInterval: 1.0f target: self selector: @selector(AfficheDiffere) userInfo: nil repeats: YES];
        
    }
    else {
            
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"PlayerSimpleViewController"];
        [self.navigationController presentViewController:controller animated:NO completion:nil];
        
    }
   
    
    
}



#pragma mark - NSFetchedResultsController


- (void)addVideoToPersistentStore:(ModelVideo *)modelvideo {
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *ent = [NSEntityDescription entityForName:@"Video" inManagedObjectContext:self.managedObjectContext];
    fetchRequest.entity = ent;
    
    // narrow the fetch to these two properties
    fetchRequest.propertiesToFetch = [NSArray arrayWithObjects:@"nom_groupe", @"titre", nil];
    [fetchRequest setResultType:NSDictionaryResultType];
    
    // before adding the earthquake, first check if there's a duplicate in the backing store
    NSError *error = nil;
    
    
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"nom_groupe = %@ AND titre = %@", modelvideo.nom_groupe, modelvideo.titre];
    
    NSArray *fetchedItems = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (fetchedItems.count == 0) {
        // add
        [self.managedObjectContext insertObject:modelvideo];
    }
    
    if ([self.managedObjectContext hasChanges]) {
        
        if (![self.managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate.
            // You should not use this function in a shipping application, although it may be useful
            // during development. If it is not possible to recover from the error, display an alert
            // panel that instructs the user to quit the application by pressing the Home button.
            //
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}


- (void)deleteVideoToPersistentStore:(ModelVideo *)modelvideo {
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *ent = [NSEntityDescription entityForName:@"Video" inManagedObjectContext:self.managedObjectContext];
    fetchRequest.entity = ent;
    
    // narrow the fetch to these two properties
    fetchRequest.propertiesToFetch = [NSArray arrayWithObjects:@"nom_groupe", @"titre", nil];
    [fetchRequest setResultType:NSDictionaryResultType];
    
    // before adding the earthquake, first check if there's a duplicate in the backing store
    NSError *error = nil;
   
    
        fetchRequest.predicate = [NSPredicate predicateWithFormat:@"nom_groupe = %@ AND titre = %@", modelvideo.nom_groupe, modelvideo.titre];
        
        NSArray *fetchedItems = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
        if (fetchedItems.count > 0) {
            // delete
            [self.managedObjectContext deleteObject:modelvideo];
        }
    
       if ([self.managedObjectContext hasChanges]) {
        
        if (![self.managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate.
            // You should not use this function in a shipping application, although it may be useful
            // during development. If it is not possible to recover from the error, display an alert
            // panel that instructs the user to quit the application by pressing the Home button.
            //
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}



- (void)UpdateVideoToPersistentStore:(ModelVideo *)oldModelvideo New:(ModelVideo *)newModelvideo {
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *ent = [NSEntityDescription entityForName:@"Video" inManagedObjectContext:self.managedObjectContext];
    fetchRequest.entity = ent;
    
    // narrow the fetch to these two properties
    fetchRequest.propertiesToFetch = [NSArray arrayWithObjects:@"nom_groupe", @"titre", nil];
    [fetchRequest setResultType:NSDictionaryResultType];
    
    // before adding the earthquake, first check if there's a duplicate in the backing store
    NSError *error = nil;
    
    
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"nom_groupe = %@ AND titre = %@", oldModelvideo.nom_groupe, oldModelvideo.titre];
    
    NSArray *fetchedItems = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (fetchedItems.count > 0) {
        // delete
        [self.managedObjectContext deleteObject:oldModelvideo];
        //add
        [self.managedObjectContext insertObject:newModelvideo];
    }
    
    if ([self.managedObjectContext hasChanges]) {
        
        if (![self.managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate.
            // You should not use this function in a shipping application, although it may be useful
            // during development. If it is not possible to recover from the error, display an alert
            // panel that instructs the user to quit the application by pressing the Home button.
            //
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}




#pragma mark - Core Data support

// The managed object context for the view controller (which is bound to the persistent store coordinator for the application).
- (NSManagedObjectContext *)managedObjectContext {
    
    if (_managedObjectContext) {
        return _managedObjectContext;
    }
    
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    _managedObjectContext.persistentStoreCoordinator = [[APLCoreDataStackManager sharedManager] persistentStoreCoordinator];
    
    return _managedObjectContext;
}



// called after fetched results controller received a content change notification
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    
    [self.tableView reloadData];
}

- (NSFetchedResultsController *)fetchedResultsController {
    
    // Set up the fetched results controller if needed.
    if (_fetchedResultsController == nil) {
        
        // Create the fetch request for the entity.
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        // Edit the entity name as appropriate.
        NSEntityDescription *entity =
        [NSEntityDescription entityForName:@"Video"
                    inManagedObjectContext:[[APLCoreDataStackManager sharedManager] managedObjectContext]];
        [fetchRequest setEntity:entity];
        
        // sort by id groupe
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"nom_groupe" ascending:NO];
        NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
        [fetchRequest setSortDescriptors:sortDescriptors];
        
        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        NSFetchedResultsController *aFetchedResultsController =
        [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                            managedObjectContext:[[APLCoreDataStackManager sharedManager] managedObjectContext]
                                              sectionNameKeyPath:@"nom_groupe"
                                                       cacheName:@"nom_groupe"];
        self.fetchedResultsController = aFetchedResultsController;
        
        self.fetchedResultsController.delegate = self;
        
        NSError *error = nil;
        
        if (![self.fetchedResultsController performFetch:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate.
            // You should not use this function in a shipping application, although it may be useful
            // during development. If it is not possible to recover from the error, display an alert
            // panel that instructs the user to quit the application by pressing the Home button.
            //
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
    
    return _fetchedResultsController;
}




@end