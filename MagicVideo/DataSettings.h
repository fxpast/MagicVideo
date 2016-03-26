#import <UIKit/UIKit.h>


@interface DataSettings : NSObject
{
    NSString *_openURL;
}

@property(nonatomic, retain) NSString *openURL;
+(id) singleton;

@end
