

#import <Foundation/Foundation.h>

@interface DataSettings : NSObject
{
    NSString *_openURL;
    NSString *_id_categ;
    
}

@property(nonatomic, retain) NSString *id_categ;
@property(nonatomic, retain) NSString *openURL;
+(id) singleton;

@end
