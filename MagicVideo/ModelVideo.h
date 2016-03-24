//
//  NSObject+ModelVideo.h
//  MagicVideo
//
//  Created by MacbookPRV on 18/03/2016.
//  Copyright © 2016 Pastouret Roger. All rights reserved.
//



@import Foundation;
@import CoreData;
@import UIKit;

@interface ModelVideo : NSManagedObject


@property  int id_groupe;
@property (strong, nonatomic) NSString *nom_groupe;
@property (strong, nonatomic) NSString *adresseVideo;
@property (strong, nonatomic) UIImage *imageVideo;
@property (strong, nonatomic) NSString *titre;

@end
