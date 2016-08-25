//
//  WMAudioHelper.h
//  WorksMovie
//
//  Created by Naver on 2016. 8. 2..
//  Copyright © 2016년 worksmobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "WMVideoModelManager.h"
#import "WMAudioModelManager.h"

@interface WMAudioHelper : NSObject

- (instancetype)initWithVideoModelManager:(WMVideoModelManager *)videoModelManager audioModelManager:(WMAudioModelManager *)audioModelManager;

- (NSURL *)setupFile;
- (void)addVideoToModelManager:(NSURL *)videoURL;
- (void)setupAudioRecorder:(NSURL *)outputFileURL;
- (void)startRecording;
- (void)pauseRecording;
- (void)stopRecording;
- (BOOL)isRecording;

- (AVMutableComposition *)mergeAudio:(NSURL *)audioURL withVideo:(NSURL *)videoURL audioAvailable:(BOOL)audioAvailable;
- (NSURL *)storeVideo:(AVMutableComposition *)composition videoComposition:(AVVideoComposition *)videoComposition;
- (UIActivityViewController *)shareVideo:(NSURL *)outputURL;

@end
