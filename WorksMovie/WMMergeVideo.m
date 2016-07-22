//
//  WMMergeVideo.m
//  WorksMovie
//
//  Created by Naver on 2016. 7. 22..
//  Copyright © 2016년 worksmobile. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>
#import "WMMergeVideo.h"

@interface WMMergeVideo ()

@property (nonatomic, strong) WMModelManager *modelManager;
@property (nonatomic, strong) NSMutableArray *assets;
@property (nonatomic, strong) AVMutableComposition *composition;

@end


@implementation WMMergeVideo

- (instancetype)initWithModelManager:(WMModelManager *)modelManager {
    self = [super init];
    
    if(self) {
        self.modelManager = modelManager;
    }
    return self;
}

// modalManager의 videoData들을(촬영된 비디오들의 url) asset으로 생성
- (void)setupAssetsOfVideoDatas {
    self.assets = [[NSMutableArray alloc] init];
    
    for(int i = 0 ; i < [self.modelManager.videoDatas count] ; i++) {
        [self.assets addObject:[AVAsset assetWithURL:[(WMModel *)self.modelManager.videoDatas[i] videoURL]]];
    }
}

// 촬영된 1개 이상의 비디오를 하나로 병합시키는 기능
- (AVMutableComposition *)mergeVideo {
    [self setupAssetsOfVideoDatas];
    
    self.composition = [[AVMutableComposition alloc] init];
    AVMutableCompositionTrack *compositionVideoTrack = [self.composition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    
    CGAffineTransform transform = CGAffineTransformMakeRotation((90 * M_PI ) / 180);
    compositionVideoTrack.preferredTransform = transform;
    
    AVMutableCompositionTrack *soundtrackTrack = [self.composition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    CMTime insertTime = kCMTimeZero;
    
    for(AVAsset *videoAsset in self.assets){    //촬영된 비디오의 asset들을 돌면서 각 compositionVideoTrack과 soundtrackTrack을 하나의 track으로 연속해 이어붙임
        [compositionVideoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoAsset.duration) ofTrack:[[videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] atTime:insertTime error:nil];
        [soundtrackTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoAsset.duration) ofTrack:[[videoAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0] atTime:insertTime error:nil];
        
        insertTime = CMTimeAdd(insertTime, videoAsset.duration); // 다음 insert를 위해 insertTime을 갱신
    }
    
    return self.composition;
}

// 저장된 파일을 내보낼 path생성
- (NSString *)outputPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *uuid = [[NSUUID UUID] UUIDString];
    NSString *outputVideoPath =  [documentsDirectory stringByAppendingPathComponent:
                                  [NSString stringWithFormat:@"%@%@", uuid, @".mov"]];
    return outputVideoPath;
}

- (AVAssetExportSession *)exportVideo {
    NSString *outputVideoPath = [self outputPath];
    NSURL *outputVideoURL = [NSURL fileURLWithPath:outputVideoPath];
    
    AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:self.composition presetName:AVAssetExportPresetHighestQuality];
    
    exporter.outputURL=outputVideoURL;
    exporter.outputFileType = AVFileTypeQuickTimeMovie;
    exporter.shouldOptimizeForNetworkUse = YES;
    
    return exporter;
}


@end
