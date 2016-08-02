//
//  WMPlayAndStoreVideoViewController.m
//  WorksMovie
//
//  Created by Naver on 2016. 7. 7..
//  Copyright © 2016년 worksmobile. All rights reserved.
//

#import "WMPlayAndStoreVideoViewController.h"
#import "WMShowVideosViewController.h"
#import "WMVideoHelper.h"

@interface WMPlayAndStoreVideoViewController ()

@property (nonatomic, strong) WMModelManager *modelManager;
@property (nonatomic, strong) WMVideoHelper *videoHelper;
@property (nonatomic, strong) UIView *videoView;
@property (nonatomic, strong) UIButton *backToCameraViewButton;
@property (nonatomic, strong) UIButton *resetAndbackToCameraButton;
@property (nonatomic, strong) UIButton *playVideoButton;
@property (nonatomic, strong) UIView *videoStoreMenuContainerView;
@property (nonatomic, strong) UIButton *storeVideoButton;
@property (nonatomic, strong) UIButton *shareVideoButton;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *returnToShootingVideoViewButton;
@property (nonatomic, strong) AVQueuePlayer *player;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;
@property (nonatomic, strong) AVPlayerItem *playerItem;

@end

@implementation WMPlayAndStoreVideoViewController

- (instancetype)initWithVideoModelManager:(WMModelManager *)modelManager {
    self = [super init];
    
    if(self) {
        self.modelManager = modelManager;
        self.videoHelper = [[WMVideoHelper alloc] initWithModelManager:self.modelManager];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupComponents];
    [self setupConstraints];
    
    [self preparePlayVideo];
}


#pragma mark - Create Views Methods

- (void)setupComponents {
    [self setupVideoView];
    [self setupBackToCameraViewButton];
    [self setupResetAndbackToCameraButton];
    [self setupPlayVideoButton];
    [self setupVideoStoreMenuContainerView];
    [self setupStoreVideoButton];
    [self setupShareVideoButton];
}

- (void)setupVideoView {
    self.videoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-200)];
    self.videoView.translatesAutoresizingMaskIntoConstraints = NO;
    
    UIImageView *imageView = [self.videoHelper gettingThumbnailFromVideoInView:self.videoView withURL:[(WMModel *)self.modelManager.videoDatas[0] videoURL]];
    
    [self.videoView addSubview:imageView];
    [self.view addSubview:self.videoView];
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(videoViewTapped:)];
    [self.videoView addGestureRecognizer:tapRecognizer];
}


- (void)setupBackToCameraViewButton {
    self.backToCameraViewButton = [[UIButton alloc] init];
    [self.backToCameraViewButton setImage:[UIImage imageNamed:@"backButton"] forState:UIControlStateNormal];
    self.backToCameraViewButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.videoView addSubview:self.backToCameraViewButton];
    [self.backToCameraViewButton addTarget:self action:@selector(backToCameraViewButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)setupResetAndbackToCameraButton {
    self.resetAndbackToCameraButton = [[UIButton alloc] init];
    [self.resetAndbackToCameraButton setImage:[UIImage imageNamed:@"videoButton"] forState:UIControlStateNormal];
    self.resetAndbackToCameraButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.videoView addSubview:self.resetAndbackToCameraButton];
    [self.resetAndbackToCameraButton addTarget:self action:@selector(resetAndbackToCameraButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)setupPlayVideoButton {
    self.playVideoButton = [[UIButton alloc] init];
    [self.playVideoButton setImage:[UIImage imageNamed:@"Play"] forState:UIControlStateNormal];
    self.playVideoButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.videoView addSubview:self.playVideoButton];
    self.playVideoButton.enabled = NO;
}

- (void)setupVideoStoreMenuContainerView {
    self.videoStoreMenuContainerView = [[UIView alloc] initWithFrame:CGRectZero];
    self.videoStoreMenuContainerView.backgroundColor = [UIColor colorWithRed:0.15 green:0.16 blue:0.17 alpha:1.00];
    self.videoStoreMenuContainerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.videoStoreMenuContainerView];
}

- (void)setupStoreVideoButton {
    self.storeVideoButton = [[UIButton alloc] init];
    [self.storeVideoButton
     setImage:[UIImage imageNamed:@"saveButton"] forState:UIControlStateNormal];
    self.storeVideoButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.videoStoreMenuContainerView addSubview:self.storeVideoButton];
    [self.storeVideoButton addTarget:self action:@selector(storeVideoButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupShareVideoButton {
    self.shareVideoButton = [[UIButton alloc] init];
    [self.shareVideoButton
     setImage:[UIImage imageNamed:@"shareButton"] forState:UIControlStateNormal];
    self.shareVideoButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.videoStoreMenuContainerView addSubview:self.shareVideoButton];
    [self.shareVideoButton addTarget:self action:@selector(shareVideoButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
}


#pragma mark - Setup Constraints Methods

- (void)setupConstraints {
    [self setupVideoViewConstraints];
    [self setupBackToCameraViewButtonConstraints];
    [self setupResetAndbackToCameraButtonConstraints];
    [self setupPlayVideoButtonConstraints];
    [self setupVideoStoreMenuContainerViewConstraints];
    [self setupStoreVideoButtonConstraints];
    [self setupShareVideoButtonConstraints];

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

- (void)setupBackToCameraViewButtonConstraints {
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[backToCameraViewButton(==40)]"
                                            options:0
                                            metrics:nil
                                               views:@{@"backToCameraViewButton" : self.backToCameraViewButton}]];
    
     [self.view addConstraints:
        [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[backToCameraViewButton(==40)]"
                                            options:0
                                            metrics:nil
                                                views:@{@"backToCameraViewButton" : self.backToCameraViewButton}]];
}

- (void)setupResetAndbackToCameraButtonConstraints {
    [self.view addConstraints:
        [NSLayoutConstraint constraintsWithVisualFormat:@"H:[resetAndbackToCameraButton(==40)]-20-|"
                                                options:0
                                                metrics:nil
                                                    views:@{@"resetAndbackToCameraButton" : self.resetAndbackToCameraButton}]];
    
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[resetAndbackToCameraButton(==40)]"
                                             options:0
                                             metrics:nil
                                               views:@{@"resetAndbackToCameraButton" : self.resetAndbackToCameraButton}]];
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

- (void)setupVideoStoreMenuContainerViewConstraints {
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[videoStoreMenuContainerView]|"
                                             options:0
                                             metrics:nil
                                               views:@{@"videoStoreMenuContainerView" : self.videoStoreMenuContainerView}]];
    
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:[videoStoreMenuContainerView(==200)]|"
                                             options:0
                                             metrics:nil
                                               views:@{@"videoView" : self.videoView, @"videoStoreMenuContainerView" : self.videoStoreMenuContainerView}]];
}

- (void)setupStoreVideoButtonConstraints {
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-70-[storeVideoButton]"
                                             options:0
                                             metrics:nil
                                               views:@{@"storeVideoButton" : self.storeVideoButton}]];
    
    [self.view addConstraint:
     [NSLayoutConstraint constraintWithItem:self.videoStoreMenuContainerView
                                  attribute:NSLayoutAttributeCenterY
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self.storeVideoButton
                                  attribute:NSLayoutAttributeCenterY
                                 multiplier:1
                                   constant:0]];
}

- (void)setupShareVideoButtonConstraints {
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:[shareVideoButton]-70-|"
                                             options:0
                                             metrics:nil
                                               views:@{@"shareVideoButton" : self.shareVideoButton}]];
    
    [self.view addConstraint:
     [NSLayoutConstraint constraintWithItem:self.videoStoreMenuContainerView
                                  attribute:NSLayoutAttributeCenterY
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self.shareVideoButton
                                  attribute:NSLayoutAttributeCenterY
                                 multiplier:1
                                   constant:0]];
}


#pragma mark - Prepare Play Video

- (void)preparePlayVideo {
    // 로직 부분 클래스 옮기기
    NSMutableArray *videoItems = [self fetchPlayerItem];
    
    [self setupItemDidFinishActionWithVideoItems:videoItems];
    [self setupPlayerViewLayerWithVideoItems:videoItems];
}

- (NSMutableArray *)fetchPlayerItem {
    NSMutableArray *videoItems = [[NSMutableArray alloc] init];
    
    for (int i = 0 ; i < self.modelManager.videoDatas.count; i++) {
        self.playerItem = [AVPlayerItem playerItemWithURL:[(WMModel *)self.modelManager.videoDatas[i] videoURL]];
        [videoItems addObject:self.playerItem];
    }
    return videoItems;
}

// 동영상 play가 끝나면 불릴 notification 등록
- (void)setupItemDidFinishActionWithVideoItems:(NSArray *)videoItems {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(itemDidFinishPlaying:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification object:self.playerItem];
}

- (void)setupPlayerViewLayerWithVideoItems:(NSArray *)videoItems {
    self.player = [[AVQueuePlayer alloc] initWithItems:videoItems];
    
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    [self.playerLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    self.playerLayer.frame = self.videoView.frame;
}


#pragma mark - Video View Tapped Event Handler Methods

// viewView를 tap하면 비디오의 재생 상태에 따라 play또는 pause시킨다.
- (void)videoViewTapped:(UITapGestureRecognizer*)sender {
    if([self isPlaying]) {
        self.playVideoButton.hidden = NO;
        self.backButton.hidden = NO;
        [self.player pause];
    } else {
        self.playVideoButton.hidden = YES;
        self.backButton.hidden = YES;
        
        [self.videoView.layer insertSublayer:self.playerLayer below:self.playVideoButton.layer];
        [self.player play];
        
    }
}

- (BOOL)isPlaying {
    if (self.player.rate == 0.0) { // player가 정지 상태일 때 실행
        return NO;
    }
    return YES;
}


// 비디오 재생이 끝나면 리플레이를 위해 preparePlayVideo를 호출한다.
-(void)itemDidFinishPlaying:(NSNotification *) notification {
//    [self preparePlayVideo];
    
//    AVPlayerItem *playerItem = [notification object];
//    [self.player advanceToNextItem];
    
    AVPlayerItem *currentItem = [notification object];
    [currentItem seekToTime:kCMTimeZero];
    [self.player advanceToNextItem];
    [self.player insertItem:currentItem afterItem:nil];
    [self.player pause];
   
    self.playVideoButton.hidden = NO;
    self.backButton.hidden = NO;
}



#pragma mark - back To Camera View Button Event Handler Methods

// backToCamerViewButton을 누르면 카메라 촬영화면으로 되돌아 간다.
- (void)backToCameraViewButtonClicked:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - reset And back To Camera Button Event Handler Methods

//resetAndbackToCameraButton을 누르면 촬영한 데이터가 모두 삭제되고 카메라 촬영화면으로 되돌아간다.
- (void)resetAndbackToCameraButtonClicked:(UIButton *)sender {
    [self.modelManager.videoDatas removeAllObjects];
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Store Video Button Event Handler Methods

- (void)storeVideoButtonClicked:(UIButton *)sender {
    [self.videoHelper mergeVideo];
    [self.videoHelper storeVideo];
    
}


#pragma mark - Share Video Button Event Handler Methods

- (void)shareVideoButtonClicked:(UIButton *)sender {
    [self.videoHelper mergeVideo];
    NSURL *url = [self.videoHelper storeVideo];

    UIActivityViewController *activityView = [self.videoHelper shareVideo:url];
    [self presentViewController:activityView animated:YES completion:nil];
}

@end
