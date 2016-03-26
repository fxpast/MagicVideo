/*
	
	Abstract:
	Camera preview view.
*/

#import <UIKit/UIKit.h>

@class AVCaptureSession;

@interface AAPLCameraPreviewView : UIView

@property (nonatomic) AVCaptureSession *session;

@end
