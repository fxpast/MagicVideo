//
//  NSObject+ModelVideo.h
//  MagicVideo
//
//  Created by MacbookPRV on 18/03/2016.
//  Copyright © 2016 Pastouret Roger. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface  ModelVideo: NSObject {
    
    NSURL *adresseVideo;
    NSString *titre;
    NSString *categorie;
    UIImage *imageVideo;
    
    
}

@property (strong, nonatomic) NSURL *adresseVideo;
@property (strong, nonatomic) UIImage *imageVideo;
@property (strong, nonatomic) NSString *titre;
@property (strong, nonatomic) NSString *categorie;



@end
