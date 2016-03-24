//
//  PopViewController.m
//  Popovers
//
//  Created by Jay Versluis on 17/10/2015.
//  Copyright © 2015 Pinkstone Pictures LLC. All rights reserved.
//

#import "CategoryTableViewController.h"
#import "SavVideo.h"
#import "ModelCategorie.h"
#import "APLCoreDataStackManager.h"

@import CoreData;

@interface CategoryTableViewController() <NSFetchedResultsControllerDelegate>

{
     SavVideo *wSavvideo;
     NSTimer *Wtimer;
    
}


@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@property (strong, nonatomic) NSMutableArray *TableauCategorie;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *buttonEdit;


@end

@implementation CategoryTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     //self.TableauCategorie =[[NSMutableArray alloc] init];
     wSavvideo = [SavVideo singleton];
    //demarrer le Wtimer
    Wtimer = [NSTimer scheduledTimerWithTimeInterval: 1.0f target: self selector: @selector(AfficheDiffere) userInfo: nil repeats: YES];

    
}

-(void) viewWillAppear:(BOOL)animated {
    
    
    [super viewWillAppear:animated];

    
    if (wSavvideo.addCateg)
    {
        ModelCategorie *model = [[ModelCategorie alloc] init];
        model.id_gr = wSavvideo.id_categ;
        model.nom = wSavvideo.categorie;
        wSavvideo.addCateg = false;
        [self addCategorieToPersistentStore:model];
        self.buttonEdit.enabled=true;
        [self.tableView reloadData];
        
    }
    else {
        self.buttonEdit.enabled=false;
    }

    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void) AfficheDiffere {
    
    
    if (wSavvideo.addCateg) {
        [self viewWillAppear:true];
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
        
        ModelCategorie *model = [self.fetchedResultsController objectAtIndexPath:indexPath];
        [self deleteCategorieToPersistentStore:model];
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
    ModelCategorie *model = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.textLabel.text = model.nom;
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    if ([wSavvideo.categorie isEqual: model.nom] ) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else {
        
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
    
    
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ModelCategorie *model = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    if (self.editing) {
        
        
        wSavvideo.id_categ = model.id_gr;
        wSavvideo.categorie = model.nom;
      
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"CategoryViewController"];
        [self.navigationController presentViewController:controller animated:NO completion:nil];
        
    }
    else {
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"CategoryViewController"];
        [self.navigationController presentViewController:controller animated:NO completion:nil];
        
    }
    
    
    
}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
   
    
    
    
    ModelVideo *model = [savvideo.TableauVideo objectAtIndex:indexPath.row];
    savvideo.url = [NSURL URLWithString:model.adresseVideo] ;
    
    if (self.editing) {
        
        savvideo.titre=model.titre;
        savvideo.id_categ = model.id_groupe;
        savvideo.categorie = model.nom_groupe;
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"CategoryViewController"];
        [self.navigationController presentViewController:controller animated:NO completion:nil];
        
    }
    else {
         wSavvideo.categorie = [self.TableauCategorie objectAtIndex:indexPath.row];
        [self dismissViewControllerAnimated:YES completion:nil];

    }
    

    
    
    
}




#pragma mark - NSFetchedResultsController


- (void)addCategorieToPersistentStore:(ModelVideo *)modelvideo {
    
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


- (void)deleteCategorieToPersistentStore:(ModelVideo *)modelvideo {
    
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



- (void)updateCategorieToPersistentStore:(ModelVideo *)oldModelvideo New:(ModelVideo *)newModelvideo {
    
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
        [NSEntityDescription entityForName:@"Categorie"
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
                                              sectionNameKeyPath:nil
                                                       cacheName:nil];
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
