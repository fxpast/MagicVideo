
#import "DataSettings.h"

@implementation DataSettings
{
    BOOL flgInit;
}


@synthesize openURL=_openURL, id_categ=_id_categ;

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
            instance.id_categ=[DataDico objectForKey:@"id_categ"];
            instance->flgInit=false;
            
		}
		

	
	return instance;
	
}


#pragma mark propriete openURL
- (NSString *)getopenURL {
		return _openURL;
}

- (void)setopenURL:(NSString *)openurl {
    
    _openURL=openurl;
    if (!flgInit) [self enregistrer];
    
}


#pragma mark propriete id_categ
- (NSString *)getid_categ {
    return _id_categ;
}

- (void)setid_categ:(NSString *)idcateg {
    
    _id_categ=idcateg;
    if (!flgInit) [self enregistrer];
    
}



-(void) enregistrer
{
    
    NSDictionary *dico = [[NSDictionary alloc] initWithObjectsAndKeys:self.id_categ,@"id_categ", self.openURL,@"openURL", nil ];
    
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"parametres.plist"];
    [dico writeToFile:plistPath atomically:YES];
  
    
}




@end
