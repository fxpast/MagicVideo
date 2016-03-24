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
    BOOL addCateg;
    BOOL addVideo;
    BOOL updatCateg;
    BOOL updatVideo;
    UIImage *image;
    
}

@property BOOL addCateg;
@property BOOL addVideo;
@property BOOL updatCateg;
@property BOOL updatVideo;
@property  int id_categ;
@property (strong, nonatomic) NSString *categorie;
@property (strong, nonatomic) NSString *titre;
@property (strong, nonatomic) NSURL  *url;
@property (strong, nonatomic) UIImage *image;

+ (id) singleton;

@end


