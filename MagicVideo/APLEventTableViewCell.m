
/*
     File: APLEventTableViewCell.m
 Abstract: Table view cell to display information about an event.
 The cell layout is mainly defined in the storyboard, but some Auto Layout constraints are redefined programmatically.
 
  
 
 */

#import "APLEventTableViewCell.h"
#import "APLEvent.h"
#import "APLTag.h"

@interface APLEventTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imagevideo;
@property (nonatomic, weak, readwrite) IBOutlet UITextField *nameField;
@property (nonatomic, weak) IBOutlet UILabel *creationDateLabel;
@property (nonatomic, weak) IBOutlet UITextField *tagsField;
@property (nonatomic, weak) IBOutlet UIButton *tagsButton;

@end


@implementation APLEventTableViewCell


- (IBAction)editTags:(id)sender
{
    /*
     Send message to delegate -- the table view controller -- to start editing tags.
     */
    [self.delegate performSegueWithIdentifier:@"EditTags" sender:self];
    
    
}


- (void)configureWithEvent:(APLEvent *)event
{
	self.nameField.text = event.name;
    self.imagevideo.image = [UIImage imageWithData:event.imagevideo];
	self.creationDateLabel.text = [self.dateFormatter stringFromDate:[event creationDate]];
	
	NSMutableArray *eventTagNames = [NSMutableArray new];
	for (APLTag *tag in event.tags) {
		[eventTagNames addObject:tag.name];
	}
	
	NSString *tagsString = @"";
	if ([eventTagNames count] > 0) {
		tagsString = [eventTagNames componentsJoinedByString:@", "];
	}
	self.tagsField.text = tagsString;
}


- (BOOL)makeNameFieldFirstResponder
{
	return [self.nameField becomeFirstResponder];
}


/*
 When the table view becomes editable, the cell should:
 * Hide the location label (so that the Delete button does not overlap it)
 * Enable the name field (to make it editable)
 * Display the tags button
 * Set a placeholder for the tags field (so the user knows to tap to edit tags)
 * Move the visible views out of the way of the edit icon.
 The inverse applies when the table view has finished editing.
 */
 
- (void)willTransitionToState:(UITableViewCellStateMask)state
{
	[super willTransitionToState:state];
	
	if (state & UITableViewCellStateEditingMask) {
		self.nameField.enabled = YES;
		self.tagsButton.hidden = NO;
		self.tagsField.placeholder = NSLocalizedString(@"Toucher pour modifier le tag", @"Texte pour les champs d'etiquette dans le tableau principal");
	}
}


- (void)didTransitionToState:(UITableViewCellStateMask)state
{
	[super didTransitionToState:state];
	
	if (!(state & UITableViewCellStateEditingMask)) {
		self.nameField.enabled = NO;
		self.tagsButton.hidden = YES;
		self.tagsField.placeholder = @"";
	}
}

#pragma mark - Internationalization

/*
 Reset the date and number formatters if the locale changes.
 */

+(void)initialize
{
    [[NSNotificationCenter defaultCenter] addObserverForName:NSCurrentLocaleDidChangeNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        
        sDateFormatter = nil;
        sNumberFormatter = nil;
    }];
}


// A date formatter for the creation date.
- (NSDateFormatter *)dateFormatter
{
    return [[self class] dateFormatter];
}


static NSDateFormatter *sDateFormatter = nil;

+ (NSDateFormatter *)dateFormatter
{
	if (sDateFormatter == nil) {
		sDateFormatter = [[NSDateFormatter alloc] init];
		[sDateFormatter setTimeStyle:NSDateFormatterShortStyle];
		[sDateFormatter setDateStyle:NSDateFormatterMediumStyle];
	}
    return sDateFormatter;
}

// A number formatter for the latitude and longitude.
- (NSNumberFormatter *)numberFormatter
{
    return [[self class] numberFormatter];
}


static NSNumberFormatter *sNumberFormatter = nil;

+ (NSNumberFormatter *)numberFormatter
{
	if (sNumberFormatter == nil) {
		sNumberFormatter = [[NSNumberFormatter alloc] init];
		[sNumberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
		[sNumberFormatter setMaximumFractionDigits:3];
	}
    return sNumberFormatter;
}

#pragma mark - Layout

/*
 Auto Layout workaround:
 
 Constraints made in the storyboard to the superview of views in the content view are made instead to the table view cell itself. This means that when the cell enters the editing state the content is not properly moved out of the way of the editing icons (the content view is shrunk to move content out of the way). A workaround is to remove the inappropriate constraints and recreate them substituting the content view for self.
 */
- (void)awakeFromNib
{
    NSArray *constraints = [self.constraints copy];
    
    for (NSLayoutConstraint *constraint in constraints) {
        
        id firstItem = constraint.firstItem;
        if (firstItem == self) {
            firstItem = self.contentView;
        }
        id secondItem = constraint.secondItem;
        if (secondItem == self) {
            secondItem = self.contentView;
        }
        
        NSLayoutConstraint *fixedConstraint = [NSLayoutConstraint constraintWithItem:firstItem attribute:constraint.firstAttribute relatedBy:constraint.relation toItem:secondItem attribute:constraint.secondAttribute multiplier:constraint.multiplier constant:constraint.constant];
        
        [self removeConstraint:constraint];
        [self.contentView addConstraint:fixedConstraint];
    }
}


@end
