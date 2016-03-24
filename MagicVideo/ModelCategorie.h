//
//  NSObject+ModelVideo.h
//  MagicVideo
//
//  Created by MacbookPRV on 18/03/2016.
//  Copyright © 2016 Pastouret Roger. All rights reserved.
//



@import Foundation;
@import CoreData;

@interface ModelCategorie : NSManagedObject


@property  int id_gr;
@property (strong, nonatomic) NSString *nom;

@end
