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

@interface  TableViewController()


@property (weak, nonatomic) IBOutlet UIBarButtonItem *buttonEdit;


@end


@implementation TableViewController {
    
    SavVideo *savvideo;
    
}


-(void) viewDidLoad {
    
    savvideo = [SavVideo singleton];
    
}

-(void) viewWillAppear:(BOOL)animated {
    
    
    [super viewDidAppear:animated];
    
   if (savvideo.TableauVideo.count>0)
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

    if (savvideo.TableauVideo.count>0) {
        return savvideo.TableauVideo.count;
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
    
    
    
    if (savvideo.TableauVideo.count>0) {
        [savvideo.TableauVideo removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        
    }

    
    if (savvideo.TableauVideo.count==0) {

        self.buttonEdit.title=@"Edit";
        self.editing = false;
        self.buttonEdit.enabled = false;
        
    }

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
      
        
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    ModelVideo *model = [savvideo.TableauVideo objectAtIndex:indexPath.row];
    cell.imageView.image = model.imageVideo;
    cell.textLabel.text = model.adresseVideo.absoluteString;
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.accessoryType = UITableViewCellAccessoryNone;
    return cell;
    
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
   
    ModelVideo *model = [savvideo.TableauVideo objectAtIndex:indexPath.row];
    savvideo.url = model.adresseVideo;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"PlayerSimpleViewController"];
    [self.navigationController presentViewController:controller animated:NO completion:nil];
    
    
    
}






@end