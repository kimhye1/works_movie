//
//  WMRecordAudioViewController.m
//  WorksMovie
//
//  Created by Naver on 2016. 7. 26..
//  Copyright © 2016년 worksmobile. All rights reserved.
//

#import "WMRecordAudioViewController.h"
#import "WMPlayAndStoreAudioViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "WMAudioHelper.h"
#import "WMMediaUtils.h"

@interface WMRecordAudioViewController ()

@property (nonatomic, strong) WMAudioHelper *audioHelper;
@property (nonatomic, strong) UIView *videoView;
@property (nonatomic, strong) UIButton *backToCellectionViewButton;
@property (nonatomic, strong) UIButton *playVideoButton;
@property (nonatomic, strong) UIView *recordAudioContainerView;
@property (nonatomic, strong) PHAsset *asset;
@property (nonatomic, strong) NSURL *videoURL;
@property (nonatomic, strong) UIButton *recordButton;
@property (nonatomic, strong) UIView *recordingSquare;
@property (nonatomic, strong) UIView *recordingMark;
@property (nonatomic, strong) UILabel *recordingTimeLabel;
@property (nonatomic, assign) int time;
@property (nonatomic, strong) UIButton *removeAudioButton;
@property (nonatomic, strong) UIButton *completeRecordingButton;
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;
@property (nonatomic, strong) AVPlayer *playerWithAudio;
@property (nonatomic, strong) AVPlayerLayer *playerLayerWithAudio;
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property (nonatomic, strong) NSURL *outputFileURL;
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, strong) NSTimer *recordPorgresstimer;
@property (nonatomic, strong) NSTimer *recordMarkTimer;
@property (nonatomic, assign) double videoRunningTime;

@end

@implementation WMRecordAudioViewController

- (instancetype)initWithVideoURL:(NSURL *)videoURL {
    self = [super init];
    
    if (self) {
        self.videoURL = videoURL;
        self.audioHelper = [[WMAudioHelper alloc] init];
    }
    return self;
  
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupViewComponents];
    [self setupConstraints];
    
    [self preparePlayVideo];
    [self prepareRecordAudio];
    [self preparePlayVideoWhenRocorded];
}


#pragma mark - Create Views Methods

- (void)setupViewComponents {
    [self setupVideoView];
    [self setupBackToCellectionViewButton];
    [self setupPlayVideoButton];
    [self setupProgressView];
    [self setupRecordAudioContainerView];
    [self setupRecordButton];
    [self setupRecordingStateView];
    [self setupRemoveAudioButton];
    [self setupCompleteRecordingButton];
}

- (void)setupVideoView {
    self.videoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-200)];
    self.videoView.translatesAutoresizingMaskIntoConstraints = NO;
    
    // thumbnail 추출
    UIImageView *imageView = [WMMediaUtils gettingThumbnailFromVideoInView:self.videoView withURL:self.videoURL];
    
    [self.videoView addSubview:imageView];
    [self.view addSubview:self.videoView];
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(videoViewTapped:)];
    [self.videoView addGestureRecognizer:tapRecognizer];
}

- (void)setupBackToCellectionViewButton {
    self.backToCellectionViewButton = [[UIButton alloc] init];
    [self.backToCellectionViewButton setImage:[UIImage imageNamed:@"backButton"] forState:UIControlStateNormal];
    self.backToCellectionViewButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.videoView addSubview:self.backToCellectionViewButton];
    [self.backToCellectionViewButton addTarget:self action:@selector(backToCollectionViewButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupPlayVideoButton {
    self.playVideoButton = [[UIButton alloc] init];
    [self.playVideoButton setImage:[UIImage imageNamed:@"Play"] forState:UIControlStateNormal];
    self.playVideoButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.videoView addSubview:self.playVideoButton];
    self.playVideoButton.enabled = NO;
}

- (void)setupProgressView {
    self.progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    self.progressView.frame = CGRectMake(0, self.view.frame.size.height - 200, self.view.frame.size.width, 7);
    self.progressView.progress = 0.0f;
    self.progressView.transform = CGAffineTransformMakeScale(1.0, 2.0);
    self.progressView.trackTintColor = [UIColor colorWithRed:0.13 green:0.13 blue:0.13 alpha:1.00];
    self.progressView.progressTintColor = [UIColor whiteColor];
    [self.progressView setProgressViewStyle:UIProgressViewStyleBar];
    self.playVideoButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.progressView];
}

- (void)setupRecordAudioContainerView {
    self.recordAudioContainerView = [[UIView alloc] initWithFrame:CGRectZero];
    self.recordAudioContainerView.backgroundColor = [UIColor colorWithRed:0.15 green:0.16 blue:0.17 alpha:1.00];
    self.recordAudioContainerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.recordAudioContainerView];
}

- (void)setupRecordButton {
    self.recordButton = [[UIButton alloc] init];
    self.recordButton.frame = CGRectMake(0, 0, 70, 70);
    self.recordButton.backgroundColor = [UIColor redColor];
    self.recordButton.clipsToBounds = YES;
    self.recordButton.layer.cornerRadius = 70 / 2.0f;
    self.recordButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.recordButton.layer.borderWidth = 2.0f;
    self.recordButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.recordAudioContainerView addSubview:self.recordButton];
    
    self.recordingSquare = [[UIView alloc] init];
    self.recordingSquare.frame = CGRectMake(0, 0, 25, 25);
    self.recordingSquare.backgroundColor = [UIColor redColor];
    self.recordingSquare.layer.cornerRadius = 5;
    self.recordingSquare.translatesAutoresizingMaskIntoConstraints = NO;
    [self.recordButton addSubview:self.recordingSquare];
    self.recordingSquare.hidden = YES;
    [self.recordButton addTarget:self action:@selector(recordButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupRecordingStateView {
    self.recordingMark = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 7, 7)];
    
    self.recordingMark.backgroundColor = [UIColor redColor];
    self.recordingMark.clipsToBounds = YES;
    self.recordingMark.layer.cornerRadius = 7 / 2.0f;
    self.recordingMark.translatesAutoresizingMaskIntoConstraints = NO;
    [self.recordAudioContainerView addSubview:self.recordingMark];
    
    self.recordingTimeLabel = [[UILabel alloc] init];
    self.recordingTimeLabel.text = @"00 sec";
    self.recordingTimeLabel.textColor = [UIColor whiteColor];
    [self.recordingTimeLabel setFont:[UIFont systemFontOfSize:14]];
    self.recordingTimeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.recordAudioContainerView addSubview:self.recordingTimeLabel];
}

- (void)setupRemoveAudioButton {
    self.removeAudioButton = [[UIButton alloc] init];
    [self.removeAudioButton setTitle:@"취소" forState:UIControlStateNormal];
    [self.removeAudioButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.removeAudioButton.titleLabel setFont:[UIFont systemFontOfSize:20]];
    self.removeAudioButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.recordAudioContainerView addSubview:self.removeAudioButton];
    [self.removeAudioButton addTarget:self action:@selector(removeAudioButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)setupCompleteRecordingButton {
    self.completeRecordingButton = [[UIButton alloc] init];
    [self.completeRecordingButton setTitle:@"완료" forState:UIControlStateNormal];
    [self.completeRecordingButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.completeRecordingButton.titleLabel setFont:[UIFont systemFontOfSize:20]];
    self.completeRecordingButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.recordAudioContainerView addSubview:self.completeRecordingButton];
    self.completeRecordingButton.hidden = YES;
    [self.completeRecordingButton addTarget:self action:@selector(completeRecordingButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
}


#pragma mark - Setup Constraints Methods

- (void)setupConstraints {
    [self setupVideoViewConstraints];
    [self setupBackToCellectionViewButtonConstraints];
    [self setupPlayVideoButtonConstraints];
    [self setupProgressViewConstraints];
    [self setupRecordAudioContainerViewConstraints];
    [self setupRecordButtonConstraints];
    [self setupRecordingStateViewConstraints];
    [self setupRemoveAudioButtonConstraint];
    [self setupCompleteRecordingButtonConstraints];
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

- (void)setupBackToCellectionViewButtonConstraints {
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[backToCellectionViewButton(==40)]"
                                             options:0
                                             metrics:nil
                                               views:@{@"backToCellectionViewButton" : self.backToCellectionViewButton}]];
    
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[backToCellectionViewButton(==40)]"
                                             options:0
                                             metrics:nil
                                               views:@{@"backToCellectionViewButton" : self.backToCellectionViewButton}]];
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

- (void)setupProgressViewConstraints {
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[progressView]|"
                                             options:0
                                             metrics:nil
                                               views:@{@"progressView" : self.progressView}]];
}

- (void)setupRecordAudioContainerViewConstraints {
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[RecordAudioContainerView]|"
                                             options:0
                                             metrics:nil
                                               views:@{@"RecordAudioContainerView" : self.recordAudioContainerView}]];
    
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:[RecordAudioContainerView(==198)]|"
                                             options:0
                                             metrics:nil
                                               views:@{@"RecordAudioContainerView" : self.recordAudioContainerView}]];
}

- (void)setupRecordButtonConstraints {
    [self.view addConstraint:
     [NSLayoutConstraint constraintWithItem:self.view
                                  attribute:NSLayoutAttributeCenterX
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self.recordButton
                                  attribute:NSLayoutAttributeCenterX
                                 multiplier:1
                                   constant:0]];
    
    [self.view addConstraint:
     [NSLayoutConstraint constraintWithItem:self.recordAudioContainerView
                                  attribute:NSLayoutAttributeCenterY
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self.recordButton
                                  attribute:NSLayoutAttributeCenterY
                                 multiplier:1
                                   constant:0]];
    
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:[recordButton(==70)]"
                                             options:0
                                             metrics:nil
                                               views:@{@"recordButton" : self.recordButton}]];
    
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:[recordButton(==70)]"
                                             options:0
                                             metrics:nil
                                               views:@{@"recordButton" : self.recordButton}]];

    [self.view addConstraint:
     [NSLayoutConstraint constraintWithItem:self.recordButton
                                  attribute:NSLayoutAttributeCenterX
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self.recordingSquare
                                  attribute:NSLayoutAttributeCenterX
                                 multiplier:1
                                   constant:0]];
    
    [self.view addConstraint:
     [NSLayoutConstraint constraintWithItem:self.recordButton
                                  attribute:NSLayoutAttributeCenterY
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self.recordingSquare
                                  attribute:NSLayoutAttributeCenterY
                                 multiplier:1
                                   constant:0]];
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:[recordingSquare(==25)]"
                                             options:0
                                             metrics:nil
                                               views:@{@"recordingSquare" : self.recordingSquare}]];
    
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:[recordingSquare(==25)]"
                                             options:0
                                             metrics:nil
                                               views:@{@"recordingSquare" : self.recordingSquare}]];
}

- (void)setupRecordingStateViewConstraints {
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:[recordingMark(==7)]-7-[recordingTimeLabel]-10-|"
                                             options:0
                                             metrics:nil
                                               views:@{@"recordingMark" : self.recordingMark, @"recordingTimeLabel" : self.recordingTimeLabel}]];
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-11-[recordingMark(==7)]"
                                             options:0
                                             metrics:nil
                                               views:@{@"recordingMark" : self.recordingMark}]];
    
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[recordingTimeLabel]"
                                             options:0
                                             metrics:nil
                                               views:@{@"recordingTimeLabel" : self.recordingTimeLabel}]];
}

- (void)setupRemoveAudioButtonConstraint {
    [self.view addConstraint:
     [NSLayoutConstraint constraintWithItem:self.recordAudioContainerView
                                  attribute:NSLayoutAttributeCenterY
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self.removeAudioButton
                                  attribute:NSLayoutAttributeCenterY
                                 multiplier:1
                                   constant:0]];
    
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:[removeAudioButton]-40-[recordButton]-40-[completeRecordingButton]"
                                             options:0
                                             metrics:nil
                                               views:@{@"removeAudioButton" : self.removeAudioButton, @"recordButton" : self.recordButton, @"completeRecordingButton" : self.completeRecordingButton}]];
}

- (void)setupCompleteRecordingButtonConstraints {
    [self.view addConstraint:
     [NSLayoutConstraint constraintWithItem:self.recordAudioContainerView
                                  attribute:NSLayoutAttributeCenterY
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self.completeRecordingButton
                                  attribute:NSLayoutAttributeCenterY
                                 multiplier:1
                                   constant:0]];
}


#pragma mark - Prepare Record Audio / Play Video Method

- (void)prepareRecordAudio {
    self.outputFileURL = [self.audioHelper setupFile];
    [self.audioHelper setupAudioRecorder:self.outputFileURL];
}

- (void)preparePlayVideo {
    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:self.videoURL options:nil];
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:avAsset];
    
    // 동영상 play가 끝나면 불릴 notification 등록
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(itemDidFinishPlaying:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification object:playerItem];
    
    self.player = [AVQueuePlayer playerWithPlayerItem:playerItem];
    
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    [self.playerLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    self.playerLayer.frame = self.videoView.frame;
}

- (void)preparePlayVideoWhenRocorded {
    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:self.videoURL options:nil];
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:avAsset];
    
    // 동영상 play가 끝나면 불릴 notification 등록
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(itemDidFinishPlayingWithRecord:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification object:playerItem];
    
    self.playerWithAudio = [AVPlayer playerWithPlayerItem:playerItem];
    
    self.playerLayerWithAudio = [AVPlayerLayer playerLayerWithPlayer:self.playerWithAudio];
    [self.playerLayerWithAudio setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    self.playerLayerWithAudio.frame = self.videoView.frame;
    
    self.time = 0;
}


#pragma mark - Video View Tapped Event Handler Methods

// viewView를 tap하면 비디오의 재생 상태에 따라 play또는 pause시킨다.
- (void)videoViewTapped:(UITapGestureRecognizer *)sender {
    if (self.player.rate == 1.0) { // 재생 중일 때 실행
        self.playVideoButton.hidden = NO;
        self.backToCellectionViewButton.hidden = NO;
        [self.player pause];
    } else if (self.player.rate == 0.0) { // 정지 상태일 때 실행
        self.playVideoButton.hidden = YES;
        self.backToCellectionViewButton.hidden = YES;
        [self.videoView.layer insertSublayer:self.playerLayer below:self.playVideoButton.layer];
        [self.player play];
    }
}


#pragma mark - Record Audio Button Event Handler Methods

- (void)recordButtonClicked:(UIButton *)sender {
    self.videoView.userInteractionEnabled = NO; // 녹음을 진행하는 동안 viewView 클릭 이벤트가 발생해 video가 play되는 것을 막는다.
    
    if (![self.audioHelper isRecording]) {
        self.recordButton.backgroundColor = [UIColor colorWithRed:0.15 green:0.16 blue:0.17 alpha:1.00];
        self.recordingSquare.hidden = NO;
        self.recordingSquare.userInteractionEnabled = NO;
        
        [self.videoView.layer addSublayer:self.playerLayerWithAudio];
        self.playVideoButton.hidden = YES;
        [self.playerWithAudio play];
        
        [self.audioHelper startRecording];
        
        self.recordPorgresstimer = [NSTimer scheduledTimerWithTimeInterval:0.01
                                                      target:self
                                                    selector:@selector(updateProgressBar)
                                                    userInfo:nil
                                                     repeats:YES]; //0.01초 마다 updateProgressing를 호출
        
        self.recordMarkTimer = [NSTimer scheduledTimerWithTimeInterval:1
                                                                target:self
                                                              selector:@selector(updateRecordingProgress)
                                                              userInfo:nil
                                                               repeats:YES]; //1초마다 updateRecordingProgress 호출
    } else {
        self.recordButton.backgroundColor = [UIColor redColor];
        self.recordingSquare.hidden = YES;
        
        [self.videoView addSubview:self.playVideoButton];
        self.playVideoButton.hidden = NO;
        [self.playerWithAudio pause];
        
        [self.audioHelper pauseRecording];
        
        [self.progressView setProgress:self.progress animated:NO];
        
        [self.recordPorgresstimer invalidate]; //timer 진행을 멈춘다.
        
        [self.recordMarkTimer invalidate];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    AVURLAsset *avUrl = [AVURLAsset URLAssetWithURL:self.videoURL options:nil];
    CMTime time = [avUrl duration];
    self.videoRunningTime = ceil(time.value / time.timescale);
}

// record progress의 현재 상태를 업데이트 한다.
- (void)updateProgressBar {
    double eachProgress = 0.01 / self.videoRunningTime;
    
    self.progress += eachProgress;
    self.progressView.progress = self.progress;
}

- (void)updateRecordingProgress {
    [self updateRecordingTime];
    [self fadaAnimatioin];
}

// 녹음 시간을 초 단위로 업데이트
- (void)updateRecordingTime {
    self.time++;
    self.recordingTimeLabel.text = [NSString stringWithFormat:@"%@%d%@", @"0", self.time, @" sec"];
    if (self.time >= 10) {
        self.recordingTimeLabel.text = [NSString stringWithFormat:@"%d%@", self.time, @" sec"];
    }

}

// recoding mark를 1초마다 fade in/out
- (void)fadaAnimatioin {
    //fade in
    [UIView animateWithDuration:1.0f animations:^{
        [self.recordingMark setAlpha:1.0f];
        
    } completion:^(BOOL finished) {
        //fade out
        [UIView animateWithDuration:1.0f animations:^{
            [self.recordingMark setAlpha:0.0f];
        } completion:nil];
    }];
}


#pragma mark - Video Play End Event

// 비디오 재생이 끝나면 리플레이를 위해 preparePlayVideo를 호출한다.
- (void)itemDidFinishPlaying:(NSNotification *)notification {
    [self preparePlayVideo];
    
    self.playVideoButton.hidden = NO;
    self.backToCellectionViewButton.hidden = NO;
}

- (void)itemDidFinishPlayingWithRecord:(NSNotification *)notification {
    [self showCompleteButton];
    
    [self.recordMarkTimer invalidate];
    
    self.recordButton.backgroundColor = [UIColor redColor];
    self.recordingSquare.hidden = YES;
    [self.videoView addSubview:self.playVideoButton];
    self.playVideoButton.hidden = NO;
    [self.videoView addSubview:self.backToCellectionViewButton];
    self.videoView.userInteractionEnabled = YES;
    self.completeRecordingButton.userInteractionEnabled = YES;
}

// 녹음이 끝나면 완료 버튼을 노출
- (void)showCompleteButton {
    self.completeRecordingButton.hidden = NO;
    
    [self.completeRecordingButton setAlpha:0.0f];
    
    [UIView animateWithDuration:0.5f animations:^{ // fade in
        [self.completeRecordingButton setAlpha:1.0f];
    } ];
}


#pragma mark - Remove Audio Button Event Handler Methods

- (void)removeAudioButtonClicked:(UIButton *)sender {
    [self alertResetAudio];
}

// audio를 reset할 것인지 alert 창을 띄워 확인
- (void)alertResetAudio {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"음성 녹음을 취소하겠습니까?"
                                  message:nil
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok = [UIAlertAction
                         actionWithTitle:@"아니요"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction *action) {
                             [alert dismissViewControllerAnimated:YES completion:nil];
                             
                         }];
    
     __weak typeof(self) weakSelf = self;
    UIAlertAction *cancel = [UIAlertAction
                             actionWithTitle:@"예"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction *action) {
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                 [weakSelf dismissViewControllerAnimated:NO completion:nil];
                                 
                             }];
    [alert addAction:ok];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
}


#pragma mark - Complete Recording Button Event Handler Methods

- (void)completeRecordingButtonClicked:(UIButton *)sender {
    [self.audioHelper stopRecording];
    
    WMPlayAndStoreAudioViewController *playAndStoreViewController = [[WMPlayAndStoreAudioViewController alloc] initWithAudioURL:self.outputFileURL videoURL:self.videoURL];
    [self presentViewController:playAndStoreViewController animated:YES completion:nil];
}


#pragma mark - Back To Collection View Button Event Handler Methods

- (void)backToCollectionViewButtonClicked:(UIButton *)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}

@end
