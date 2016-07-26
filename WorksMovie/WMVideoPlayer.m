//
//  WMPlayVideo.m
//  WorksMovie
//
//  Created by Naver on 2016. 7. 14..
//  Copyright © 2016년 worksmobile. All rights reserved.
//

#import "WMVideoPlayer.h"

@interface WMVideoPlayer ()

@property (nonatomic, strong) WMModelManager *modelManager;

@end

@implementation WMVideoPlayer

- (instancetype)initWithModelManager:(WMModelManager *)modelManager {
    self = [super init];
    
    if(self) {
        self.modelManager = modelManager;
    }
    return self;
}

// 촬영된 비디오로부터 썸네일을 추출하여 추출된 still 이미지를 imageView에 추가한 후 imageView를 반환
- (UIImageView *)gettingThumbnailFromVideoInView:(UIView *)videoView {
    AVURLAsset* asset = [AVURLAsset URLAssetWithURL:[(WMModel *)self.modelManager.videoDatas[0] videoURL] options:nil]; // 썸네일을 생성하기 위해 첫 번째 비디오의 url을 파라미터를 AVURLAsset에 넣는다.
    AVAssetImageGenerator* imageGenerator = [AVAssetImageGenerator assetImageGeneratorWithAsset:asset];
    [imageGenerator setAppliesPreferredTrackTransform:true];
    UIImage* image = [UIImage imageWithCGImage:[imageGenerator copyCGImageAtTime:CMTimeMake(1, 10) actualTime:nil error:nil]]; // 특정 시점의 이미지를 추출
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = videoView.bounds;
    
    return imageView;
}

- (void)playVideo:(UIView *)videoView {
    NSMutableArray *videoItems = [[NSMutableArray alloc] init];
    
    for (int i = 0 ; i < self.modelManager.videoDatas.count; i++) {
        AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:[(WMModel *)self.modelManager.videoDatas[i] videoURL]];
        [videoItems addObject:playerItem];
    }
    AVQueuePlayer *player = [[AVQueuePlayer alloc] initWithItems:videoItems];
    
    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:player];
    [playerLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    playerLayer.frame = videoView.frame;
    
    [videoView.layer addSublayer:playerLayer];
    
    [player play];
}

@end
