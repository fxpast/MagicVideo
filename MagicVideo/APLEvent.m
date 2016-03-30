
/*
     File: APLEvent.m
 Abstract: A Core Data managed object class to represent an event containing geographical coordinates and a time stamp.
 An event has a to-many relationship to Tag which represents tags associated with the event.
  Version: 2.3
  
 */

#import "APLEvent.h"
#import "APLTag.h"

@implementation APLEvent 

@dynamic name, creationDate, imagevideo, adresseVideo, tags, tag;

@end
