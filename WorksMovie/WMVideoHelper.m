//
//  WMVideoHelper.m
//  WorksMovie
//
//  Created by Naver on 2016. 7. 26..
//  Copyright © 2016년 worksmobile. All rights reserved.
//

#import "WMVideoHelper.h"
#import "WMVideoRecorder.h"
#import "WMVideoPlayer.h"
#import "WMVideoSaver.h"
#import "WMVideoSharer.h"


@interface WMVideoHelper ()

@property (nonatomic, strong) WMVideoRecorder *videoRecorder;
@property (nonatomic, strong) WMVideoPlayer *videoPlayer;
@property (nonatomic, strong) WMVideoSaver *videoSaver;
@property (nonatomic, strong) WMVideoSharer *VideoSharer;

@end

@implementation WMVideoHelper

- (instancetype)initWithModelManager:(WMModelManager *)modelManager {
    
    self = [super self];
    
    if (self) {
        self.videoRecorder = [[WMVideoRecorder alloc] initWithModelManager:modelManager];
        self.videoPlayer = [[WMVideoPlayer alloc] initWithModelManager:modelManager];
        self.videoSaver = [[WMVideoSaver alloc] initWithModelManager:modelManager];
        self.VideoSharer = [[WMVideoSharer  alloc] init];
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

- (UIImageView *)gettingThumbnailFromVideoInView:(UIView *)videoView {
    return [self.videoPlayer gettingThumbnailFromVideoInView:videoView];
}

- (void)playVideo:(UIView *)videoView {
    [self.videoPlayer playVideo:videoView];
}

- (void)mergeVideo {
    [self.videoSaver mergeVideo];
}

- (NSURL *)storeVideo {
    return [self.videoSaver storeVideo];
}

- (UIActivityViewController *)shareVideo:(NSURL *)outputURL {
    return [self.VideoSharer shareVideo:outputURL];
}



@end
