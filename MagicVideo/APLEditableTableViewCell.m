
/*
     File: APLEditableTableViewCell.m
 Abstract: Table view cell to present an editable text field to display tag names.
 The cell layout is mainly defined in the storyboard, but some Auto Layout constraints are redefined programmatically.
 
   
 */

#import "APLEditableTableViewCell.h"

@interface APLEditableTableViewCell ()

@property (nonatomic, weak) IBOutlet UITextField *textField;
@property (nonatomic) IBOutletCollection (NSLayoutConstraint) NSArray *originalConstraints;
@property (nonatomic) NSArray *contentViewConstraints;

@end



@implementation APLEditableTableViewCell

-(void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];

    // Edit the text field should only be enabled when in editing mode.
    self.textField.enabled = editing;

    /*
     Auto Layout workaround:

     Constraints made in the storyboard to the superview of views in the content view are made instead to the table view cell itself. This means that when the cell enters the editing state the content is not properly moved out of the way of the editing icons (the content view is shrunk to move content out of the way).
    */

    // Remove original constraints.
    if (self.originalConstraints != nil) {
        [self removeConstraints:self.originalConstraints];
        self.originalConstraints = nil;
    }

    /*
     The constraints are different for editing/not editing, so create different visual format strings for each. Keep a reference to the constraints so they can be removed next time round.
    */
    
    // Remove any existing constraints from the content view.
    if (self.contentViewConstraints != nil) {
        [self.contentView removeConstraints:self.contentViewConstraints];
    }
    
    NSDictionary *viewBindingsDictionary = @{ @"textField" : self.textField };
    NSString *visualFormatString;
    if (editing) {
        visualFormatString = @"|-8-[textField]-|";
    }
    else {
        visualFormatString = @"|-[textField]-|";
    }

    // Create the new constraints.
    self.contentViewConstraints = [NSLayoutConstraint constraintsWithVisualFormat:visualFormatString options:0 metrics:nil views:viewBindingsDictionary];

    // Add the constraints to the content view.
    [self.contentView addConstraints:self.contentViewConstraints];
}


@end
