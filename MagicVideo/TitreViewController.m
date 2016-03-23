//
//  ViewController.m
//  Popovers
//
//  Created by Jay Versluis on 17/10/2015.
//  Copyright © 2015 Pinkstone Pictures LLC. All rights reserved.
//

#import "TitreViewController.h"
#import "SavVideo.h"


@interface TitreViewController ()  
{
    
    SavVideo *wSavvideo;
   
}

@property (weak, nonatomic) IBOutlet UITextField *titre;

@end

@implementation TitreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    wSavvideo = [SavVideo singleton];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)ActionButton:(id)sender {
    
    wSavvideo.titre = self.titre.text;
    [self dismissViewControllerAnimated:YES completion:nil];

}


@end
