//
//  NSObject+SavVideo.m
//  MagicVideo
//
//  Created by MacbookPRV on 18/03/2016.
//  Copyright © 2016 Pastouret Roger. All rights reserved.
//

#import "SavVideo.h"



@implementation SavVideo
{
    
}

@synthesize TableauVideo, url, titre, categorie, addCateg;



+ (id) singleton {
    
    static SavVideo *Zinstance = nil;
    
    if (Zinstance == nil)
    {
        Zinstance = [[self alloc] init];
        Zinstance.TableauVideo =[[NSMutableArray alloc] init];
        
    }
    
    return Zinstance;
    
}




@end
