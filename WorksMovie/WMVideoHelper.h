//
//  WMVideoHelper.h
//  WorksMovie
//
//  Created by Naver on 2016. 7. 26..
//  Copyright © 2016년 worksmobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "WMModelManager.h"

@interface WMVideoHelper : NSObject

- (instancetype)initWithModelManager:(WMModelManager *)modelManager;

- (void)setupCaptureSession;
- (void)setupPreviewLayerInView:(UIView *)view;
- (void)switchCamera;
- (void)startRecording;
- (void)stopRecording;

- (UIImageView *)gettingThumbnailFromVideoInView:(UIView *)videoView withURL:(NSURL *)url;
- (void)playVideo:(UIView *)videoView;

- (void)mergeVideo;
- (NSURL *)storeVideo;

- (UIActivityViewController *)shareVideo:(NSURL *)outputURL;

@property (nonatomic, strong) WMModelManager *modelManager;

@end
