//
//  ViewController.m
//  Popovers
//
//  Created by Jay Versluis on 17/10/2015.
//  Copyright © 2015 Pinkstone Pictures LLC. All rights reserved.
//

#import "DetailViewController.h"
#import "SavVideo.h"
#import "DataSettings.h"

@interface DetailViewController ()
{
    
    SavVideo *wSavvideo;
     DataSettings *WVarPermnt;
    NSTimer *Wtimer;
}


@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UITextField *titre;
@property (weak, nonatomic) IBOutlet UILabel *okButton;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    wSavvideo = [SavVideo singleton];
    WVarPermnt = [DataSettings singleton];
    self.okButton.hidden = true;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewDidAppear:(BOOL)animated {
    
    
    [super viewWillAppear:animated];
    
    self.titre.text = wSavvideo.titre;
    self.image.image = wSavvideo.image;
    
}

- (IBAction)ActionButton:(id)sender {
    
    wSavvideo.titre = self.titre.text;
    [self dismissViewControllerAnimated:YES completion:nil];

}
- (IBAction)ActionActiverDemarrage:(id)sender {
    
    WVarPermnt.openURL = wSavvideo.url.absoluteString;
    self.okButton.hidden = false;
    Wtimer = [NSTimer scheduledTimerWithTimeInterval: 1.0f target: self selector: @selector(AfficheDiffere) userInfo: nil repeats: NO];

}


- (IBAction)ActionDesactiverDemarrage:(id)sender {
    
    WVarPermnt.openURL = @"";
    self.okButton.hidden = false;
    Wtimer = [NSTimer scheduledTimerWithTimeInterval: 1.0f target: self selector: @selector(AfficheDiffere) userInfo: nil repeats: NO];
}




-(void) AfficheDiffere {
    
    
   self.okButton.hidden = true;
    [Wtimer invalidate];
    Wtimer=nil;
    
}



@end
