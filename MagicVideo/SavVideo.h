//
//  NSObject+SavVideo.h
//  MagicVideo
//
//  Created by MacbookPRV on 18/03/2016.
//  Copyright © 2016 Pastouret Roger. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface SavVideo : NSObject
{
    NSURL  *url;
    BOOL addVideo;
    BOOL pageVideo;
    UIImage *image;
    NSMutableArray *eventsArray;    
}

@property BOOL addVideo;
@property BOOL pageVideo;
@property (strong, nonatomic) NSURL  *url;
@property (strong, nonatomic) UIImage *image;
@property (nonatomic) NSMutableArray *eventsArray;


+ (id) singleton;

@end


