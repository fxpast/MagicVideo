
#import "DataSettings.h"

@implementation DataSettings
{
    BOOL flgInit;
}


@synthesize openURL=_openURL;

+(id) singleton {
	
	static DataSettings *instance = nil;
	

		if (instance == nil)  
		{
			instance = [[self alloc] init];

            NSPropertyListFormat format;
            NSString *plistPath;
            NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                                      NSUserDomainMask, YES) objectAtIndex:0];
            plistPath = [rootPath stringByAppendingPathComponent:@"parametres.plist"];
            if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath]) {
                plistPath = [[NSBundle mainBundle] pathForResource:@"parametres" ofType:@"plist"];
            }
            NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:plistPath];
            NSDictionary *DataDico = (NSDictionary *) [NSPropertyListSerialization propertyListWithData:plistXML options:NSPropertyListImmutable format:&format error:nil];
            instance->flgInit=true;
            instance.openURL=[DataDico objectForKey:@"openURL"];
            instance->flgInit=false;
            
		}
		

	
	return instance;
	
}


#pragma mark propriete openURL
-(NSString*) openURL {
    return _openURL;
}



-(void) setOpenURL:(NSString *)openurl {
    _openURL=openurl;
    if (!flgInit) [self enregistrer];
}




-(void) enregistrer
{
    
    NSDictionary *dico = [[NSDictionary alloc] initWithObjectsAndKeys:self.openURL,@"openURL", nil ];
    
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"parametres.plist"];
    [dico writeToFile:plistPath atomically:YES];
  
    
}




@end
