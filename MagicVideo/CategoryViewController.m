//
//  ViewController.m
//  Popovers
//
//  Created by Jay Versluis on 17/10/2015.
//  Copyright © 2015 Pinkstone Pictures LLC. All rights reserved.
//

#import "CategoryViewController.h"
#import "SavVideo.h"


@interface CategoryViewController ()
{
    
    SavVideo *wSavvideo;
    
}

@property (weak, nonatomic) IBOutlet UITextField *category;

@end

@implementation CategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     wSavvideo = [SavVideo singleton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)ActionButton:(id)sender {
    
    
    wSavvideo.categorie = self.category.text;
    [self dismissViewControllerAnimated:YES completion:nil];

}



@end
