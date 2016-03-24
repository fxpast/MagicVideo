//
//  ViewController.m
//  Popovers
//
//  Created by Jay Versluis on 17/10/2015.
//  Copyright © 2015 Pinkstone Pictures LLC. All rights reserved.
//

#import "CategoryViewController.h"
#import "SavVideo.h"
#import "DataSettings.h"

@interface CategoryViewController ()
{
    
    SavVideo *wSavvideo;
    DataSettings *WVarPermnt;
    
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

-(void) viewDidAppear:(BOOL)animated {
    
    
    
    [super viewDidAppear:animated];
    self.category.text = wSavvideo.categorie;
}

- (IBAction)ActionButton:(id)sender {
    

    
    if (self.category.text.length > 0) {
        wSavvideo.categorie = self.category.text;
        wSavvideo.id_categ = WVarPermnt.id_categ.intValue + 1;
        WVarPermnt.id_categ =[NSString stringWithFormat:@"%d", wSavvideo.id_categ];
        wSavvideo.addCateg=true;
        
    }
    [self dismissViewControllerAnimated:YES completion:nil];

}


@end
