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
    UIImage *image;
}

@property BOOL addVideo;
@property (strong, nonatomic) NSURL  *url;
@property (strong, nonatomic) UIImage *image;

+ (id) singleton;

@end


