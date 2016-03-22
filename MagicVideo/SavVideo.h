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
    
}


@property (strong, nonatomic) NSMutableArray *TableauVideo;


+ (id) singleton;

@end


