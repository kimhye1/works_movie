//
//  WMPlayAndStoreVideoViewController.m
//  WorksMovie
//
//  Created by Naver on 2016. 7. 7..
//  Copyright © 2016년 worksmobile. All rights reserved.
//

#import "WMPlayAndStoreVideoViewController.h"
#import "WMShowVideosViewController.h"
#import "WMShootingVideoViewController.h"
#import "WMMediaUtils.h"
#import "WMVideoHelper.h"
#import "WMNotificationStrings.h"

@interface WMPlayAndStoreVideoViewController ()

@property (nonatomic, strong) WMVideoModelManager *modelManager;
@property (nonatomic, strong) WMVideoHelper *videoHelper;
@property (nonatomic, strong) UIView *videoView;
@property (nonatomic, strong) UIButton *backToCameraViewButton;
@property (nonatomic, strong) UIButton *resetAndbackToCameraButton;
@property (nonatomic, strong) UIButton *playVideoButton;
@property (nonatomic, strong) UIView *videoStoreMenuContainerView;
@property (nonatomic, strong) UIButton *storeVideoButton;
@property (nonatomic, strong) UILabel *storeLabel;
@property (nonatomic, strong) UIButton *shareVideoButton;
@property (nonatomic, strong) UILabel *shareLabel;
@property (nonatomic, strong) UIButton *returnToShootingVideoViewButton;
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;
@property (nonatomic, strong) AVPlayerItem *playerItem;
@property (nonatomic, strong) UILabel *saveAlertLabel;
@property (nonatomic, strong) AVVideoComposition *composition;
@property (nonatomic, strong) NSURL *outputURL;

@end

@implementation WMPlayAndStoreVideoViewController

- (instancetype)initWithVideoModelManager:(WMVideoModelManager *)modelManager
                              composition:(AVVideoComposition *)composition
                                outputURL:(NSURL *)outputURL
                                   filter:(WMFilter *)filter {
    self = [super init];
    
    if (self) {
        self.modelManager = modelManager;
        self.videoHelper = [[WMVideoHelper alloc] initWithVideoModelManager:self.modelManager];
        self.composition = composition;
        self.outputURL = outputURL;
        self.filter = filter;
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
    [self setupSaveAlertView];
}

- (void)setupVideoView {
    self.videoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-170)];
    self.videoView.translatesAutoresizingMaskIntoConstraints = NO;
    
    UIImageView *imageView = [WMMediaUtils gettingThumbnailFromVideoInView:self.videoView URL:self.outputURL filter:self.filter];
    
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
    
    [self setupStoreVideoButtonLabel];
}

- (void)setupStoreVideoButtonLabel {
    self.storeLabel = [[UILabel alloc] init];
    self.storeLabel.text = @"저장";
    self.storeLabel.textColor = [UIColor whiteColor];
    [self.storeLabel setFont:[UIFont systemFontOfSize:14]];
    self.storeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.videoStoreMenuContainerView addSubview:self.storeLabel];
}

- (void)setupShareVideoButton {
    self.shareVideoButton = [[UIButton alloc] init];
    [self.shareVideoButton
     setImage:[UIImage imageNamed:@"shareButton"] forState:UIControlStateNormal];
    self.shareVideoButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.videoStoreMenuContainerView addSubview:self.shareVideoButton];
    [self.shareVideoButton addTarget:self action:@selector(shareVideoButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self setupShareVideoButtonLabel];
}

- (void)setupShareVideoButtonLabel {
    self.shareLabel = [[UILabel alloc] init];
    self.shareLabel.text = @"공유";
    self.shareLabel.textColor = [UIColor whiteColor];
    [self.shareLabel setFont:[UIFont systemFontOfSize:14]];
    self.shareLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.videoStoreMenuContainerView addSubview:self.shareLabel];
}

- (void)setupSaveAlertView {
    self.saveAlertLabel = [[UILabel alloc] init];
    self.saveAlertLabel.text = @"영상을 저장했습니다.";
    self.saveAlertLabel.textColor = [UIColor whiteColor];
    self.saveAlertLabel.textAlignment = NSTextAlignmentCenter;
    self.saveAlertLabel.backgroundColor = [UIColor colorWithRed:0.15 green:0.16 blue:0.17 alpha:1.00];
    [self.saveAlertLabel setFont:[UIFont systemFontOfSize:15]];
    self.saveAlertLabel.layer.cornerRadius = 8;
    self.saveAlertLabel.clipsToBounds = YES;
    self.saveAlertLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.videoView addSubview:self.saveAlertLabel];
    self.saveAlertLabel.hidden = YES;
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
    [self setupSaveAlertViewConstraints];
}

- (void)setupVideoViewConstraints {
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[videoView]|"
                                             options:0
                                             metrics:nil
                                               views:@{@"videoView" : self.videoView}]];
    
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[videoView]-170-|"
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
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:[videoStoreMenuContainerView(==170)]|"
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
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-84-[storeLabel]"
                                             options:0
                                             metrics:nil
                                               views:@{@"storeLabel" : self.storeLabel}]];
    
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-47-[storeVideoButton]-10-[storeLabel]"
                                             options:0
                                             metrics:nil
                                               views:@{@"storeVideoButton" : self.storeVideoButton, @"storeLabel" : self.storeLabel}]];
}

- (void)setupShareVideoButtonConstraints {
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:[shareVideoButton]-70-|"
                                             options:0
                                             metrics:nil
                                               views:@{@"shareVideoButton" : self.shareVideoButton}]];
    
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:[shareLabel]-84-|"
                                             options:0
                                             metrics:nil
                                               views:@{@"shareLabel" : self.shareLabel}]];
    
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-47-[shareVideoButton]-10-[shareLabel]"
                                             options:0
                                             metrics:nil
                                               views:@{@"shareVideoButton" : self.shareVideoButton, @"shareLabel" : self.shareLabel}]];
}

- (void)setupSaveAlertViewConstraints {
    [self.view addConstraint:
     [NSLayoutConstraint constraintWithItem:self.videoView
                                  attribute:NSLayoutAttributeCenterX
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self.saveAlertLabel
                                  attribute:NSLayoutAttributeCenterX
                                 multiplier:1
                                   constant:0]];
    
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:[saveAlertLabel(==150)]"
                                             options:0
                                             metrics:nil
                                               views:@{@"saveAlertLabel" : self.saveAlertLabel}]];
    
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:[saveAlertLabel(==40)]-50-|"
                                             options:0
                                             metrics:nil
                                               views:@{@"saveAlertLabel" : self.saveAlertLabel}]];
}


#pragma mark - Prepare Play Video

- (void)preparePlayVideo {
    [self removeTemporarydirectoryFiles];
    
    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:self.outputURL options:nil];
    self.playerItem = [AVPlayerItem playerItemWithAsset:avAsset];
    self.playerItem.videoComposition = self.composition;
    
    // 동영상 play가 끝나면 불릴 notification 등록
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(itemDidFinishPlaying:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification object:self.playerItem];

    
    self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
    self.player.actionAtItemEnd = AVPlayerActionAtItemEndNone;
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    [self.playerLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    self.playerLayer.frame = self.videoView.frame;
}


#pragma mark - Video View Tapped Event Handler Methods

// viewView를 tap하면 비디오의 재생 상태에 따라 play또는 pause시킨다.
- (void)videoViewTapped:(UITapGestureRecognizer *)sender {
    if ([self isPlaying]) {
        [self.videoView addSubview:self.backToCameraViewButton];
        self.playVideoButton.hidden = NO;
        self.backToCameraViewButton.hidden = NO;
        [self.player pause];
    } else {
        self.playVideoButton.hidden = YES;
        self.backToCameraViewButton.hidden = YES;
        
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
- (void)itemDidFinishPlaying:(NSNotification *)notification {
    AVPlayerItem *p = [notification object];
    [p seekToTime:kCMTimeZero];
}

- (void)removeTemporarydirectoryFiles {
    NSFileManager *manager = [[NSFileManager alloc] init];
    
    for (WMMediaModel *data in self.modelManager.mediaDatas) {
        if ([manager fileExistsAtPath:data.mediaURL.path]) {
            [manager removeItemAtPath:data.mediaURL.path error:nil];
        }
    }
}


#pragma mark - back To Camera View Button Event Handler Methods

// backToCamerViewButton을 누르면 카메라 촬영화면으로 되돌아 간다.
- (void)backToCameraViewButtonClicked:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:WMPlayAndStoreVideoViewControllerDidDismissedNotification object:nil];
}


#pragma mark - reset And back To Camera Button Event Handler Methods

//resetAndbackToCameraButton을 누르면 촬영한 데이터가 모두 삭제되고 카메라 촬영화면으로 되돌아간다.
- (void)resetAndbackToCameraButtonClicked:(UIButton *)sender {
    [self alertResetVideo];
}

// 촬영된 모든 비디오를 reset할 것인지 alert 창을 띄워 확인
- (void)alertResetVideo {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"홈 화면으로 이동하겠습니까?"
                                                                    message:nil
                                                             preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancel = [UIAlertAction
                         actionWithTitle:@"취소"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction *action) {
                             [alert dismissViewControllerAnimated:YES completion:nil];
                             
                         }];
    
    __weak typeof(self) weakSelf = self;
    UIAlertAction *reset = [UIAlertAction
                             actionWithTitle:@"이동"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction *action) {
                                 __strong typeof(weakSelf) strongSelf = weakSelf;
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                
                                 [strongSelf.modelManager.mediaDatas removeAllObjects];
                                 
                                 dispatch_async(dispatch_get_main_queue(), ^{
                                     UIViewController *vc = strongSelf.presentingViewController;
                                     while (vc.presentingViewController) {
                                         vc = vc.presentingViewController;
                                     }
                                     
                                     [vc dismissViewControllerAnimated:YES completion:NULL];
                                     [[NSNotificationCenter defaultCenter] postNotificationName:@"WMShootingVideoViewController dismiss" object:nil];
                                 });
                             }];
    [alert addAction:cancel];
    [alert addAction:reset];
    
    [self presentViewController:alert animated:YES completion:nil];
}


#pragma mark - Store Video Button Event Handler Methods

- (void)storeVideoButtonClicked:(UIButton *)sender {
    [self.videoView addSubview:self.backToCameraViewButton];
    self.playVideoButton.hidden = NO;
    self.backToCameraViewButton.hidden = NO;
    [self.player pause];
    [self.playerLayer.player pause];
    [self.playerLayer removeFromSuperlayer];
    self.player = nil;
 
    [self.videoHelper storeVideo:self.composition outputURL:self.outputURL alertLabel:self.saveAlertLabel];
}


#pragma mark - Share Video Button Event Handler Methods

- (void)shareVideoButtonClicked:(UIButton *)sender {
    self.saveAlertLabel = nil;
    [self.player pause];
    NSURL *url = [self.videoHelper storeVideo:self.composition outputURL:self.outputURL alertLabel:(UILabel *)self.saveAlertLabel];

    UIActivityViewController *activityView = [self.videoHelper shareVideo:url];
    [self presentViewController:activityView animated:YES completion:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
