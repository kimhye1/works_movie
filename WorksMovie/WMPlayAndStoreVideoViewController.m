//
//  WMPlayAndStoreVideoViewController.m
//  WorksMovie
//
//  Created by Naver on 2016. 7. 7..
//  Copyright © 2016년 worksmobile. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "WMPlayAndStoreVideoViewController.h"
#import "WMShowVideosViewController.h"
#import "WMModel.h"

@interface WMPlayAndStoreVideoViewController ()

@property (nonatomic, strong) NSArray *videoDatas;
@property (nonatomic, strong) UIView *videoView;
@property (nonatomic, strong) UIButton *playVideoButton;
@property (nonatomic, strong) UIButton *storeVideoButton;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *returnToShootingVideoViewButton;

@end

@implementation WMPlayAndStoreVideoViewController

- (instancetype)initWithVideoDatas:(NSArray *)videoDatas {
    self = [super init];
    
    if(self) {
        self.videoDatas = videoDatas;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupComponents];
    [self setupConstraints];
}


#pragma mark - Create Views Methods

- (void)setupComponents {
    [self setupVideoView];
    [self setupPlayVideoButton];
}

- (void)setupVideoView {
    self.videoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-200)];
    self.videoView.translatesAutoresizingMaskIntoConstraints = NO;
    
    UIImageView *imageView = [self gettingThumbnailFromVideo];
    
    [self.videoView addSubview:imageView];
    [self.view addSubview:self.videoView];
}

// 촬영된 비디오로부터 썸네일을 추출하여 추출된 still 이미지를 imageView에 추가한 후 imageView를 반환
- (UIImageView *)gettingThumbnailFromVideo {
    AVURLAsset* asset = [AVURLAsset URLAssetWithURL:[(WMModel *)self.videoDatas[0] videoURL] options:nil]; // 썸네일을 생성하기 위해 첫 번째 비디오의 url을 파라미터를 AVURLAsset에 넣는다.
    AVAssetImageGenerator* imageGenerator = [AVAssetImageGenerator assetImageGeneratorWithAsset:asset];
    [imageGenerator setAppliesPreferredTrackTransform:true];
    UIImage* image = [UIImage imageWithCGImage:[imageGenerator copyCGImageAtTime:CMTimeMake(1, 10) actualTime:nil error:nil]]; // 특정 시점의 이미지를 추출
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = self.videoView.bounds;
    
    return imageView;
}

- (void)setupPlayVideoButton {
    self.playVideoButton = [[UIButton alloc] init];
    [self.playVideoButton setImage:[UIImage imageNamed:@"Play"] forState:UIControlStateNormal];
    self.playVideoButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.videoView addSubview:self.playVideoButton];
    [self.playVideoButton addTarget:self action:@selector(playVideoButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
}


#pragma mark - Setup Constraints Methods

- (void)setupConstraints {
    [self setupVideoViewConstraints];
    [self setupPlayVideoButtonConstraints];
}

- (void)setupVideoViewConstraints {
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[videoView]|"
                                             options:0
                                             metrics:nil
                                               views:@{@"videoView" : self.videoView}]];
    
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[videoView]-200-|"
                                             options:0
                                             metrics:nil
                                               views:@{@"videoView" : self.videoView}]];

}

- (void)setupPlayVideoButtonConstraints {
    [self.videoView addConstraint:
     [NSLayoutConstraint constraintWithItem:self.videoView
                                  attribute:NSLayoutAttributeCenterX
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self.playVideoButton
                                  attribute:NSLayoutAttributeCenterX
                                 multiplier:1
                                   constant:0]];
    
    [self.videoView addConstraint:
     [NSLayoutConstraint constraintWithItem:self.videoView
                                  attribute:NSLayoutAttributeCenterY
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self.playVideoButton
                                  attribute:NSLayoutAttributeCenterY
                                 multiplier:1
                                   constant:0]];
}


#pragma mark - Play Video Button Event Handler Methods

// playVideoButton을 클릭하면 videoItems를 차례대로 이어서 재생시킨다.
- (void)playVideoButtonClicked:(UIButton *)sender {
    NSMutableArray *videoItems = [[NSMutableArray alloc] init];
    
    for (int i = 0 ; i < self.videoDatas.count; i++) {
        AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:[(WMModel *)self.videoDatas[i] videoURL]];
        [videoItems addObject:playerItem];
    }
    AVQueuePlayer *player = [[AVQueuePlayer alloc] initWithItems:videoItems];
    
    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:player];
    [playerLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    playerLayer.frame = self.videoView.frame;
    
    [self.view.layer addSublayer:playerLayer];
    
    [player play];
}

@end
