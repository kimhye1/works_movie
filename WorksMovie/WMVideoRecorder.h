//
//  WMRecordVideo.h
//  WorksMovie
//
//  Created by Naver on 2016. 7. 14..
//  Copyright © 2016년 worksmobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "WMModelManager.h"

@interface WMVideoRecorder : NSObject  <AVCaptureFileOutputRecordingDelegate>

- (instancetype)initWithModelManager:(WMModelManager *)modelManager;

- (void)setupCaptureSession;
- (void)setupPreviewLayerInView:(UIView *)view;
- (void)switchCamera;
- (void)startRecording;
- (void)stopRecording;

@end
