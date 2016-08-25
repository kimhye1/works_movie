//
//  WMStoreVideo.m
//  WorksMovie
//
//  Created by Naver on 2016. 7. 14..
//  Copyright © 2016년 worksmobile. All rights reserved.
//

#import <Photos/Photos.h>
#import "WMVideoSaver.h"
#import "WMVideoModelManager.h"
#import "WMPlayAndApplyFilterViewController.h"

@interface WMVideoSaver ()

@property (nonatomic, strong) NSMutableArray *assets;
@property (nonatomic, strong) AVMutableComposition *composition;
@property (nonatomic, strong) WMVideoModelManager *modelManager;
//@property (nonatomic, strong) AVVideoComposition *videoComposition;
@property (nonatomic, strong) UILabel *saveAlertLabel;
@property (nonatomic, strong) UIView *savingView;

@end

@implementation WMVideoSaver

- (instancetype)initWithVideoModelManager:(WMVideoModelManager *)modelManager {
    self = [super init];
    
    if (self) {
        self.modelManager = modelManager;
    }
    return self;
}

// 촬영된 1개 이상의 비디오를 하나로 병합시키는 기능
- (AVMutableComposition *)mergeVideo {
    [self convertVideoDatasToAssets];
    
    self.composition = [[AVMutableComposition alloc] init];
    AVMutableCompositionTrack *compositionVideoTrack = [self.composition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    
    CGAffineTransform transform = CGAffineTransformMakeRotation((90 * M_PI ) / 180);
    compositionVideoTrack.preferredTransform = transform;
    
    AVMutableCompositionTrack *soundtrackTrack = [self.composition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    CMTime insertTime = kCMTimeZero;
    
    for (AVAsset *videoAsset in self.assets) {    //촬영된 비디오의 asset들을 돌면서 각 compositionVideoTrack과 soundtrackTrack을 하나의 track으로 연속해 이어붙임
        [compositionVideoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoAsset.duration) ofTrack:[[videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] atTime:insertTime error:nil];
        [soundtrackTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoAsset.duration) ofTrack:[[videoAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0] atTime:insertTime error:nil];
        
        insertTime = CMTimeAdd(insertTime, videoAsset.duration); // 다음 insert를 위해 insertTime을 갱신
    }
    return self.composition;
}

// modalManager의 videoData들을(촬영된 비디오들의 url) asset으로 생성
- (void)convertVideoDatasToAssets {
    self.assets = [[NSMutableArray alloc] init];
    
    for (int i = 0 ; i < [[self.modelManager.mediaDatas copy] count] ; i++) {
        [self.assets addObject:[AVAsset assetWithURL:[(WMMediaModel *)self.modelManager.mediaDatas[i] mediaURL]]];
    }
}

// 저장된 파일을 내보낼 path생성
- (NSString *)outputPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *uuid = [[NSUUID UUID] UUIDString];
    NSString *outputVideoPath =  [documentsDirectory stringByAppendingPathComponent:
                                  [NSString stringWithFormat:@"%@%@", uuid, @".mov"]];
    return outputVideoPath;
}

//카메라 롤에 merge된 비디오를 저장하는 메소드 
- (NSURL *)storeVideo:(AVVideoComposition *)videoComposition outputURL:(NSURL *)outputURL alertLabel:(UILabel *)saveAlertLabel savigView:(UIView *)savingView {
    self.saveAlertLabel = saveAlertLabel;
    self.savingView = savingView;
    
    NSString *outputVideoPath = [self outputPath];
    NSURL *outputVideoURL = [NSURL fileURLWithPath:outputVideoPath];
    
    AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:[AVAsset assetWithURL:outputURL] presetName:AVAssetExportPresetMediumQuality];
    
    exporter.outputURL = outputVideoURL;
    exporter.outputFileType = AVFileTypeQuickTimeMovie;
    exporter.shouldOptimizeForNetworkUse = YES;
    exporter.videoComposition = videoComposition;
    
    [exporter exportAsynchronouslyWithCompletionHandler:^{
        NSLog (@"created exporter. supportedFileTypes: %@", exporter.supportedFileTypes);
        switch ([exporter status]) {
            case AVAssetExportSessionStatusFailed:
                NSLog(@"Export failed: %@", [[exporter error] localizedDescription]);
                break;
            case AVAssetExportSessionStatusCancelled:
                NSLog(@"Export canceled");
                break;
            case AVAssetExportSessionStatusCompleted:
                UISaveVideoAtPathToSavedPhotosAlbum(outputVideoPath, self, @selector(video:didFinishSavingWithError:contextInfo:), nil); // 카메라 롤에 저장
                break;
            default:
                break;
        }
    }];
    return outputVideoURL;
}

- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error) {
        NSLog(@"error");
    } else {
        NSLog(@"finish saving");
        [self savedAlert:self.saveAlertLabel];
        self.savingView.hidden = YES;
    }
}

- (void)savedAlert:(UILabel *)saveAlertLabel {
    saveAlertLabel.hidden = NO;
    
    [saveAlertLabel setAlpha:0.0f];
    
    [UIView animateWithDuration:1.0f animations:^{ // fade in
        [saveAlertLabel setAlpha:1.0f];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:1.0f animations:^{ // fade out
            [saveAlertLabel setAlpha:0.0f];
        } completion:nil];
    }];
}

@end