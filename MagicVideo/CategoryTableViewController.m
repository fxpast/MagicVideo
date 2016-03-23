//
//  PopViewController.m
//  Popovers
//
//  Created by Jay Versluis on 17/10/2015.
//  Copyright © 2015 Pinkstone Pictures LLC. All rights reserved.
//

#import "CategoryTableViewController.h"
#import "SavVideo.h"


@interface CategoryTableViewController()
{
     SavVideo *wSavvideo;
     NSTimer *Wtimer;
    
}

@property (strong, nonatomic) NSMutableArray *TableauCategorie;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *buttonEdit;


@end

@implementation CategoryTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.TableauCategorie =[[NSMutableArray alloc] init];
     wSavvideo = [SavVideo singleton];
    //demarrer le Wtimer
    Wtimer = [NSTimer scheduledTimerWithTimeInterval: 0.50f target: self selector: @selector(AfficheDiffere) userInfo: nil repeats: YES];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void) AfficheDiffere {
    
    
    if (wSavvideo.addCateg) {
        [self.TableauCategorie addObject:wSavvideo.categorie];
        wSavvideo.addCateg = false;
        [self viewWillAppear:true];
    }
    
    
}

-(void) viewWillAppear:(BOOL)animated {
    
    
    [super viewDidAppear:animated];

    
    if (self.TableauCategorie.count>0)
    {
        self.buttonEdit.enabled=true;
        [self.tableView reloadData];
        
    }
    else {
        self.buttonEdit.enabled=false;
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


-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    [super tableView:tableView numberOfRowsInSection:section];
    
    if (self.TableauCategorie.count>0) {
        return self.TableauCategorie.count;
    }
    else {
        return 0;
    }
    
}


-(void) setEditing:(BOOL)editing animated:(BOOL)animated{
    
    [super setEditing:editing animated:animated];
    
    [self.tableView setEditing:editing animated:animated];
    
}




- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    if (self.TableauCategorie.count>0) {
        [self.TableauCategorie removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        
    }
    
    
    if (self.TableauCategorie.count==0) {
        
        self.buttonEdit.title=@"Edit";
        self.editing = false;
        self.buttonEdit.enabled = false;
        
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = [self.TableauCategorie objectAtIndex:indexPath.row];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    //cell.accessoryType = UITableViewCellAccessoryCheckmark;
    return cell;
    
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    wSavvideo.categorie = [self.TableauCategorie objectAtIndex:indexPath.row];
    [self dismissViewControllerAnimated:YES completion:nil];

    
}



@end
