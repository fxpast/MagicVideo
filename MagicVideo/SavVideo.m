//
//  NSObject+SavVideo.m
//  MagicVideo
//
//  Created by MacbookPRV on 18/03/2016.
//  Copyright © 2016 Pastouret Roger. All rights reserved.
//

#import "SavVideo.h"



@implementation SavVideo


@synthesize url, titre, id_categ, categorie, addVideo, updatVideo, addCateg, updatCateg, image;



+ (id) singleton {
    
    static SavVideo *Zinstance = nil;
    
    if (Zinstance == nil)
    {
        Zinstance = [[self alloc] init];
        
    }
    
    return Zinstance;
    
}




@end
