//
//  WMAudioHelper.m
//  WorksMovie
//
//  Created by Naver on 2016. 8. 2..
//  Copyright © 2016년 worksmobile. All rights reserved.
//

#import "WMAudioHelper.h"
#import "WMAudioRecorder.h"
#import "WMAudioSaver.h"

@interface WMAudioHelper ()

@property (nonatomic, strong) WMAudioRecorder *audioRecorder;
//@property (nonatomic, strong) WMMediaPlayer *audioPlayer;
@property (nonatomic, strong) WMAudioSaver *audioSaver;
//@property (nonatomic, strong) WMMediaSharer *audioSharer;

@end

@implementation WMAudioHelper

- (instancetype)initWithVideoModelManager:(WMVideoModelManager *)videoModelManager audioModelManager:(WMAudioModelManager *)audioModelManager {
    
    self = [super self];
    
    if (self) {
        self.audioRecorder = [[WMAudioRecorder alloc] initWithVideoModelManager:videoModelManager audioModelManager:audioModelManager];
//        self.audioPlayer = [[WMMediaPlayer alloc] initWithModelManager:modelManager];
        self.audioSaver = [[WMAudioSaver alloc] initWithVideoModelManager:videoModelManager audioModelManager:audioModelManager];
//        audioSharer = [[WMMediaSharer  alloc] init];
    }
    return self;
}

- (NSURL *)setupFile {
    return [self.audioRecorder setupFile];
}

- (void)addVideoToModelManager:(NSURL *)videoURL {
    [self.audioRecorder addVideoToVideoModelManager:videoURL];
}

- (void)setupAudioRecorder:(NSURL *)outputFileURL {
    [self.audioRecorder setupAudioRecorder:outputFileURL];
}

- (void)startRecording {
    [self.audioRecorder startRecording];
}

- (void)pauseRecording {
    [self.audioRecorder pauseRecording];
}

- (void)stopRecording {
    [self.audioRecorder stopRecording];
}

- (BOOL)isRecording {
    return [self.audioRecorder isRecording];
}

- (AVMutableComposition *)mergeAudio:(NSURL *)audioURL withVideo:(NSURL *)videoURL {
    return [self.audioSaver mergeAudio:audioURL withVideo:videoURL];
}

- (NSURL *)storeVideo:(AVMutableComposition *)composition {
    return [self.audioSaver storeVideo:composition];
}

@end
