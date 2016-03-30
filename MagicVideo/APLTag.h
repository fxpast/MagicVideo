
/*
     File: APLTag.h
 Abstract: A Core Data managed object class to represent a tag for events.
 
  
 
 */
#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>


@class APLEvent;


@interface APLTag :  NSManagedObject  

@property (nonatomic) NSString *name;

@property (nonatomic) NSSet *events;

@end

/*
 Core Data automatically generates these accessors at runtime.
 */
@interface APLTag (CoreDataGeneratedAccessors)

- (void)addEventsObject:(APLEvent *)value;
- (void)removeEventsObject:(APLEvent *)value;
- (void)addEvents:(NSSet *)value;
- (void)removeEvents:(NSSet *)value;

@end

