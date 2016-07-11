//
//  WMShootingVideoViewController.h
//  WorksMovie
//
//  Created by Naver on 2016. 6. 29..
//  Copyright © 2016년 worksmobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface WMShootingVideoViewController : UIViewController <AVCaptureFileOutputRecordingDelegate>

#define CAPTURE_FRAMES_PER_SECOND		20

@end
