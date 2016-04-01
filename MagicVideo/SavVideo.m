//
//  NSObject+SavVideo.m
//  MagicVideo
//
//  Created by MacbookPRV on 18/03/2016.
//  Copyright © 2016 Pastouret Roger. All rights reserved.
//

#import "SavVideo.h"



@implementation SavVideo


@synthesize url, addVideo, pageVideo, image, eventsArray;



+ (id) singleton {
    
    static SavVideo *Zinstance = nil;
    
    if (Zinstance == nil)
    {
        Zinstance = [[self alloc] init];
        Zinstance.eventsArray =[[NSMutableArray alloc] init];
    }
    
    return Zinstance;
    
}




@end
