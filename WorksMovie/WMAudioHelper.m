//
//  WMAudioHelper.m
//  WorksMovie
//
//  Created by Naver on 2016. 8. 2..
//  Copyright © 2016년 worksmobile. All rights reserved.
//

#import "WMAudioHelper.h"
#import "WMAudioRecorder.h"

@interface WMAudioHelper ()

@property (nonatomic, strong) WMAudioRecorder *audioRecorder;
//@property (nonatomic, strong) WMMediaPlayer *audioPlayer;
//@property (nonatomic, strong) WMAudioSaver *audioSaver;
//@property (nonatomic, strong) WMMediaSharer *audioSharer;

@end

@implementation WMAudioHelper

- (instancetype)init {
    
    self = [super self];
    
    if (self) {
        self.audioRecorder = [[WMAudioRecorder alloc] init];
//        self.videoPlayer = [[WMMediaPlayer alloc] initWithModelManager:modelManager];
//        self.videoSaver = [[WMVideoSaver alloc] initWithModelManager:modelManager];
//        self.VideoSharer = [[WMMediaSharer  alloc] init];
    }
    return self;
}

- (NSURL *)setupFile {
    return [self.audioRecorder setupFile];
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

@end
