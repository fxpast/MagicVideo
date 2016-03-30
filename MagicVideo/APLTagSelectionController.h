
/*
     File: APLTagSelectionController.h
 Abstract: The table view controller responsible for displaying all available tags.
 The controller is also given an Event object. Row for tags related to the event display a checkmark.  If the user taps a row, the corresponding tag is added to or removed from the event's tags relationship as appropriate.
  
 */


#import <UIKit/UIKit.h>

@class APLEvent;


@interface APLTagSelectionController : UITableViewController <UITextFieldDelegate>

@property (nonatomic) APLEvent *event;

@end
