//
//  NSObject+SavVideo.h
//  MagicVideo
//
//  Created by MacbookPRV on 18/03/2016.
//  Copyright © 2016 Pastouret Roger. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface SavVideo : NSObject
{
    NSMutableArray *TableauVideo;
    NSURL  *url;
    NSString *titre;
    NSString *categorie;
    
}


@property (strong, nonatomic) NSString *categorie;
@property (strong, nonatomic) NSString *titre;
@property (strong, nonatomic) NSURL  *url;
@property (strong, nonatomic) NSMutableArray *TableauVideo;


+ (id) singleton;

@end


