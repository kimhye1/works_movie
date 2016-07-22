//
//  WMStoreVideo.m
//  WorksMovie
//
//  Created by Naver on 2016. 7. 14..
//  Copyright © 2016년 worksmobile. All rights reserved.
//

#import <Photos/Photos.h>
#import "WMStoreVideo.h"

@interface WMStoreVideo ()

@property (nonatomic, strong) NSMutableArray *assets;
@property (nonatomic, strong) AVMutableComposition *composition;

@end

@implementation WMStoreVideo

//카메라 롤에 merge된 비디오를 저장하는 메소드 
- (void)storeVideo:(AVAssetExportSession *)exporter {
    [exporter exportAsynchronouslyWithCompletionHandler:^{
        NSLog (@"created exporter. supportedFileTypes: %@", exporter.supportedFileTypes);
        switch ([exporter status]) {
            case AVAssetExportSessionStatusFailed:
                NSLog(@"Export failed: %@", [[exporter error] localizedDescription]);
                break;
            case AVAssetExportSessionStatusCancelled:
                NSLog(@"Export canceled");
                break;
            default:
                break;
        }
        if(UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(exporter.outputURL.path)) {
            NSLog(@"video path is compatible with saved photo album");
        }
        UISaveVideoAtPathToSavedPhotosAlbum(exporter.outputURL.path, self, @selector(video:didFinishSavingWithError:contextInfo:), nil); // 카메라 롤에 저장
    }];
}

- (void)video:(NSString*)videoPath didFinishSavingWithError:(NSError*)error contextInfo:(void*)contextInfo {
    if (error) {
        NSLog(@"error");
    }
    else {
        NSLog(@"finish saving");
    }
}
     

     
@end