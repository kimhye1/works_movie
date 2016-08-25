//
//  WMVideoHelper.h
//  WorksMovie
//
//  Created by Naver on 2016. 7. 26..
//  Copyright © 2016년 worksmobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "WMVideoModelManager.h"

@interface WMVideoHelper : NSObject

- (instancetype)initWithVideoModelManager:(WMVideoModelManager *)modelManager;

- (void)setupCaptureSession;
- (void)setupPreviewLayerInView:(UIView *)view;
- (void)switchCamera;
- (void)startRecording;
- (void)stopRecording;
- (void)stopSession;
- (void)startSession;

- (UIImageView *)gettingThumbnailFromVideoInView:(UIView *)videoView withURL:(NSURL *)url;
- (void)playVideo:(UIView *)videoView;

- (AVMutableComposition *)mergeVideo;
- (NSURL *)storeVideo:(AVVideoComposition *)videoComposition outputURL:(NSURL *)outputURL alertLabel:(UILabel *)saveAlertLabel savigView:(UIView *)savingView;

- (UIActivityViewController *)shareVideo:(NSURL *)outputURL;

@property (nonatomic, strong) WMVideoModelManager *modelManager;

@end
