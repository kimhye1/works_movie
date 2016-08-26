//
//  WMPlayVideo.m
//  WorksMovie
//
//  Created by Naver on 2016. 7. 14..
//  Copyright © 2016년 worksmobile. All rights reserved.
//

#import "WMMediaPlayer.h"

@interface WMMediaPlayer ()

@property (nonatomic, strong) WMVideoModelManager *modelManager;

@end

@implementation WMMediaPlayer

- (instancetype)initWithVideoModelManager:(WMVideoModelManager *)modelManager {
    self = [super init];
    
    if (self) {
        self.modelManager = modelManager;
    }
    
    return self;
}

- (void)playVideo:(UIView *)videoView {
    NSMutableArray *videoItems = [[NSMutableArray alloc] init];
    
    for (int i = 0 ; i < self.modelManager.mediaDatas.count; i++) {
        AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:[(WMMediaModel *)self.modelManager.mediaDatas[i] mediaURL]];
        [videoItems addObject:playerItem];
    }
    AVQueuePlayer *player = [[AVQueuePlayer alloc] initWithItems:videoItems];
    
    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:player];
    [playerLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    playerLayer.frame = videoView.frame;
    
    [playerLayer removeFromSuperlayer];
    [videoView.layer addSublayer:playerLayer];
    
    [player play];
}

@end
