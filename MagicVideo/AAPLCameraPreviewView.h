/*
	
	Abstract:
	Camera preview view.
*/

@import UIKit;

@class AVCaptureSession;

@interface AAPLCameraPreviewView : UIView

@property (nonatomic) AVCaptureSession *session;

@end
