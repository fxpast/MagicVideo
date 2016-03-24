/*
 

 Abstract:
 Singleton controller to manage the main Core Data stack for the application.
 */

@import CoreData;
@import Foundation;

@interface APLCoreDataStackManager : NSObject

+ (instancetype)sharedManager;

@property (nonatomic, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, readonly) NSManagedObjectContext *managedObjectContext;

@end

