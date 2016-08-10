//
//  WMAudioRecorder.m
//  WorksMovie
//
//  Created by Naver on 2016. 8. 2..
//  Copyright © 2016년 worksmobile. All rights reserved.
//

#import "WMAudioRecorder.h"

@interface WMAudioRecorder ()

@property (nonatomic, strong) AVAudioRecorder *audioRecorder;

@end

@implementation WMAudioRecorder

// 저장될 audio 파일명, 경로 지정
- (NSURL *)setupFile {
    NSArray *pathComponents = [NSArray arrayWithObjects:
                               [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],
                               @"MyAudioMemo.m4a",
                               nil];
    return [NSURL fileURLWithPathComponents:pathComponents];
}

- (void)setupAudioRecorder:(NSURL *)outputFileURL {
    [self setupAudioSession];
    NSMutableDictionary *recordSetting = [self setupRecorderSetting];
    
    self.audioRecorder = [[AVAudioRecorder alloc] initWithURL:outputFileURL settings:recordSetting error:NULL];
    self.audioRecorder.delegate = self;
    self.audioRecorder.meteringEnabled = YES;
    [self.audioRecorder prepareToRecord];
}

// audio session을 정의
- (void)setupAudioSession {
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
}

// recorder setting을 정의
- (NSMutableDictionary *)setupRecorderSetting {
    NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc] init];
    
    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
    [recordSetting setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
    [recordSetting setValue:[NSNumber numberWithInt:2] forKey:AVNumberOfChannelsKey];
    
    return recordSetting;
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

- (BOOL)isRecording {
    if (self.audioRecorder.recording) {
        return YES;
    }
    return NO;
}

@end
