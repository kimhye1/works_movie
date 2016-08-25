//
//  WMVideoHelper.m
//  WorksMovie
//
//  Created by Naver on 2016. 7. 26..
//  Copyright © 2016년 worksmobile. All rights reserved.
//

#import "WMVideoHelper.h"
#import "WMVideoRecorder.h"
#import "WMMediaPlayer.h"
#import "WMVideoSaver.h"
#import "WMMediaSharer.h"
#import "WMMediaUtils.h"

@interface WMVideoHelper ()

@property (nonatomic, strong) WMVideoRecorder *videoRecorder;
@property (nonatomic, strong) WMMediaPlayer *videoPlayer;
@property (nonatomic, strong) WMVideoSaver *videoSaver;
@property (nonatomic, strong) WMMediaSharer *VideoSharer;

@end

@implementation WMVideoHelper

- (instancetype)initWithVideoModelManager:(WMVideoModelManager *)modelManager {
    
    self = [super self];
    
    if (self) {
        self.videoRecorder = [[WMVideoRecorder alloc] initWithVideoModelManager:modelManager];
        self.videoPlayer = [[WMMediaPlayer alloc] initWithVideoModelManager:modelManager];
        self.videoSaver = [[WMVideoSaver alloc] initWithVideoModelManager:modelManager];
        self.VideoSharer = [[WMMediaSharer  alloc] init];
    }
    return self;
}

- (void)setupCaptureSession {
    [self.videoRecorder setupCaptureSession];
}

- (void)setupPreviewLayerInView:(UIView *)view {
    [self.videoRecorder setupPreviewLayerInView:view];
}

- (void)switchCamera {
    [self.videoRecorder switchCamera];
}

- (void)startRecording {
    [self.videoRecorder startRecording];
}

- (void)stopRecording {
    [self.videoRecorder stopRecording];
}

- (void)stopSession {
    [self.videoRecorder stopSession];
}

- (void)startSession {
    [self.videoRecorder startSession];
}

- (UIImageView *)gettingThumbnailFromVideoInView:(UIView *)videoView withURL:(NSURL *)url {
    return [WMMediaUtils gettingThumbnailFromVideoInView:videoView URL:url filter:nil];
}

- (void)playVideo:(UIView *)videoView {
    [self.videoPlayer playVideo:videoView];
}

- (AVMutableComposition *)mergeVideo {
    return [self.videoSaver mergeVideo];
}

- (NSURL *)storeVideo:(AVVideoComposition *)videoComposition outputURL:(NSURL *)outputURL alertLabel:(UILabel *)saveAlertLabel savigView:(UIView *)savingView {
    return [self.videoSaver storeVideo:videoComposition outputURL:outputURL alertLabel:saveAlertLabel savigView:savingView];
}

- (UIActivityViewController *)shareVideo:(NSURL *)outputURL {
    return [self.VideoSharer shareVideo:outputURL];
}

@end
