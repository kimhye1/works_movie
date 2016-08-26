//
//  WMAudioRecorder.m
//  WorksMovie
//
//  Created by Naver on 2016. 8. 2..
//  Copyright © 2016년 worksmobile. All rights reserved.
//

#import "WMAudioRecorder.h"
#import "WMAudioModel.h"
#import "WMVideoModel.h"

@interface WMAudioRecorder ()

@property (nonatomic, strong) AVAudioRecorder *audioRecorder;
@property (nonatomic, strong) WMAudioModelManager *audioModelManager;
@property (nonatomic, strong) WMVideoModelManager *videoModelManager;
@property (nonatomic, strong) AVAudioSession *session;

@end

@implementation WMAudioRecorder

- (instancetype)initWithVideoModelManager:(WMVideoModelManager *)videoModelManager audioModelManager:(WMAudioModelManager *)audioModelManager {
    self = [super init];
    
    if (self) {
        self.videoModelManager = videoModelManager;
        self.audioModelManager = audioModelManager;
    }
    return self;
}

// 저장될 audio 파일명, 경로 지정
- (NSURL *)setupFile {
    NSString *uuid = [[NSUUID UUID] UUIDString];
    
    NSString *outputPath = [[NSString alloc] initWithFormat:@"%@%@%@", NSTemporaryDirectory(), uuid, @".m4a"];
    
    NSURL *outputURL = [[NSURL alloc] initFileURLWithPath:outputPath];
    NSFileManager *manager = [[NSFileManager alloc] init];
    
    if ([manager fileExistsAtPath:outputPath]) {
        [manager removeItemAtPath:outputPath error:nil];
    }
    return outputURL;
}

- (void)setupAudioRecorder:(NSURL *)outputFileURL {
    [self setupAudioSession];
    NSMutableDictionary *recordSetting = [self setupRecorderSetting];
    
    self.audioRecorder = [[AVAudioRecorder alloc] initWithURL:outputFileURL settings:recordSetting error:NULL];
    self.audioRecorder.delegate = self;
    self.audioRecorder.meteringEnabled = YES;
    [self.audioRecorder prepareToRecord];
    
    [self addAudioFileToAudioModelManager:outputFileURL];
}

// audio session을 정의
- (void)setupAudioSession {
    self.session = [AVAudioSession sharedInstance];
    [self.session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
}

// recorder setting을 정의
- (NSMutableDictionary *)setupRecorderSetting {
    NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc] init];
    
    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
    [recordSetting setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
    [recordSetting setValue:[NSNumber numberWithInt:2] forKey:AVNumberOfChannelsKey];
    
    return recordSetting;
}

- (void)addAudioFileToAudioModelManager:(NSURL *)outputFileURL {
    WMAudioModel *audioData = [[WMAudioModel alloc] init];
    audioData.mediaURL = outputFileURL;
    [self.audioModelManager addMediaData:audioData];
}

- (void)addVideoToVideoModelManager:(NSURL *)videoURL {
    WMVideoModel *videoData = [[WMVideoModel alloc] init];
    videoData.mediaURL = videoURL;
    [self.videoModelManager addMediaData:videoData];
}

- (void)startRecording {
    [self.audioRecorder record];
}

- (void)pauseRecording {
    [self.audioRecorder pause];
}

- (void)stopRecording {
    [self.audioRecorder stop];
}

- (void)removeSession {
    [[AVAudioSession sharedInstance] setActive:NO error:nil];
    self.session = nil;
    self.audioRecorder = nil;
}

- (BOOL)isRecording {
    if (self.audioRecorder.recording) {
        return YES;
    }
    return NO;
}

@end
