//
//  WMAudioSaver.m
//  WorksMovie
//
//  Created by Naver on 2016. 8. 2..
//  Copyright © 2016년 worksmobile. All rights reserved.
//

#import <Photos/Photos.h>
#import "WMAudioSaver.h"

@interface WMAudioSaver ()

@property (nonatomic, strong) WMVideoModelManager *videoModelManager;
@property (nonatomic, strong) WMAudioModelManager *audioModelManager;
@property (nonatomic, strong) AVMutableComposition *composition;

@end

@implementation WMAudioSaver

- (instancetype)initWithVideoModelManager:(WMVideoModelManager *)videoModelManager audioModelManager:(WMAudioModelManager *)audioModelManager {
    self = [super init];
    
    if (self) {
        self.videoModelManager = videoModelManager;
        self.audioModelManager = audioModelManager;
    }
    return self;
}

- (AVMutableComposition *)mergeAudio:(NSURL *)audioURL withVideo:(NSURL *)videoURL audioAvailable:(BOOL)audioAvailable {
    self.composition = [AVMutableComposition composition];
    
    // video
    AVURLAsset *videoAsset = [[AVURLAsset alloc]initWithURL:videoURL options:nil];
    CMTimeRange videoTimeRange = CMTimeRangeMake(kCMTimeZero, videoAsset.duration);
    
    AVMutableCompositionTrack *videoCompositionVideoTrack = [self.composition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    
    CGAffineTransform transform = CGAffineTransformMakeRotation((90 * M_PI ) / 180);
    videoCompositionVideoTrack.preferredTransform = transform;
    
    
    [videoCompositionVideoTrack insertTimeRange:videoTimeRange ofTrack:[[videoAsset tracksWithMediaType:AVMediaTypeVideo] firstObject] atTime:kCMTimeZero error:nil];
    
    // audio
    AVURLAsset *audioAsset = [[AVURLAsset alloc]initWithURL:audioURL options:nil];
//    CMTimeRange audioTimeRange = CMTimeRangeMake(kCMTimeZero, audioAsset.duration);
    
    AVMutableCompositionTrack *audioCompositionAudioTrack = [self.composition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    [audioCompositionAudioTrack insertTimeRange:videoTimeRange ofTrack:[[audioAsset tracksWithMediaType:AVMediaTypeAudio] firstObject] atTime:kCMTimeZero error:nil];
    
    
    
    // video's audio
    if (audioAvailable) { // 비디오 사운드 그대로 놔둘 때
        AVMutableCompositionTrack *videoCompositionAuidoTrack = [self.composition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
        [videoCompositionAuidoTrack insertTimeRange:videoTimeRange ofTrack:[[videoAsset tracksWithMediaType:AVMediaTypeAudio] firstObject] atTime:kCMTimeZero error:nil];
    }
    
    [self removeTemporarydirectoryFiles];
    
    return self.composition;
}

- (void)removeTemporarydirectoryFiles {
    NSFileManager *manager = [[NSFileManager alloc] init];
    
    for (int i = 0 ; i < self.audioModelManager.mediaDatas.count; i++) {
        if ([manager fileExistsAtPath:[self.audioModelManager.mediaDatas[i] mediaURL].path]) {
            [manager removeItemAtPath:[self.audioModelManager.mediaDatas[i] mediaURL].path error:nil];
        }
    }
}

// 카메라 롤에 merge된 비디오를 저장하는 메소드
- (NSURL *)storeVideo:(AVMutableComposition *)composition videoComposition:(AVVideoComposition *)videoComposition {
    NSString *outputVideoPath = [self outputPath];
    NSURL *outputVideoURL = [NSURL fileURLWithPath:outputVideoPath];
    
    AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:composition presetName:AVAssetExportPresetMediumQuality];
    
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

// 저장된 파일을 내보낼 path생성
- (NSString *)outputPath {

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);

    NSString *documentsDirectory = [paths firstObject];
    NSString *uuid = [[NSUUID UUID] UUIDString];
    NSString *outputVideoPath =  [documentsDirectory stringByAppendingPathComponent:
                                  [NSString stringWithFormat:@"%@%@", uuid, @".mov"]];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:outputVideoPath]) {
        [[NSFileManager defaultManager] removeItemAtPath:outputVideoPath error:nil];
    }
    
    return outputVideoPath;
}

- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error) {
        NSLog(@"error");
    } else {
        NSLog(@"finish saving");
    }
}

@end
