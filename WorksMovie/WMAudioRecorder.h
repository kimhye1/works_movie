//
//  WMAudioRecorder.h
//  WorksMovie
//
//  Created by Naver on 2016. 8. 2..
//  Copyright © 2016년 worksmobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "WMMultiMediaRecordProtocol.h"
#import "WMAudioModelManager.h"
#import "WMVideoModelManager.h"

@interface WMAudioRecorder : NSObject <AVAudioRecorderDelegate, AVAudioPlayerDelegate, WMMultiMediaRecordProtocol>

- (instancetype)initWithVideoModelManager:(WMVideoModelManager *)videoModelManager audioModelManager:(WMAudioModelManager *)audioModelManager;

- (NSURL *)setupFile;
- (void)setupAudioRecorder:(NSURL *)outputFileURL;
- (void)addVideoToVideoModelManager:(NSURL *)videoURL;

- (void)startRecording;
- (void)pauseRecording;
- (void)stopRecording;
- (BOOL)isRecording;
- (void)removeSession;

@end
