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

- (instancetype)initWithModelManager:(WMModelManager *)modelManager {
    
    self = [super self];
    
    if (self) {
        self.videoRecorder = [[WMVideoRecorder alloc] initWithModelManager:modelManager];
        self.videoPlayer = [[WMMediaPlayer alloc] initWithModelManager:modelManager];
        self.videoSaver = [[WMVideoSaver alloc] initWithModelManager:modelManager];
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

- (UIImageView *)gettingThumbnailFromVideoInView:(UIView *)videoView withURL:(NSURL *)url {
    return [WMMediaUtils gettingThumbnailFromVideoInView:videoView withURL:url];
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
