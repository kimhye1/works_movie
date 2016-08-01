//
//  WMRecordAudioViewController.m
//  WorksMovie
//
//  Created by Naver on 2016. 7. 26..
//  Copyright © 2016년 worksmobile. All rights reserved.
//

#import "WMRecordAudioViewController.h"

@interface WMRecordAudioViewController ()

@property (nonatomic, strong) UIView *videoView;
@property (nonatomic, strong) UIButton *backToCellectionViewButton;
@property (nonatomic, strong) UIButton *playVideoButton;
@property (nonatomic, strong) UIView *RecordAudioContainerView;
@property (nonatomic, strong) PHAsset *asset;
@property (nonatomic, strong) NSURL *videoURL;

@property (nonatomic, strong) UIButton *recordButton;
@property (nonatomic, strong) UIButton *removeAudioButton;
@property (nonatomic, strong) UIButton *completeRecordingButton;


@end

@implementation WMRecordAudioViewController

- (instancetype)initWithVideoURL:(NSURL *)videoURL {
    self = [super init];
    
    if(self) {
        self.videoURL = videoURL;
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
    [self setupBackToCellectionViewButton];
    [self setupPlayVideoButton];
    [self setupRecordAudioContainerView];
    
    [self setupRecordButton];
    [self setupRemoveAudioButton];
    [self setupCompleteRecordingButton];
}

- (void)setupVideoView {
    self.videoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-200)];
    self.videoView.translatesAutoresizingMaskIntoConstraints = NO;
    
    // thumbnail 추출
    AVURLAsset* asset = [AVURLAsset URLAssetWithURL:self.videoURL options:nil];
    AVAssetImageGenerator* imageGenerator = [AVAssetImageGenerator assetImageGeneratorWithAsset:asset];
    [imageGenerator setAppliesPreferredTrackTransform:true];
    UIImage* image = [UIImage imageWithCGImage:[imageGenerator copyCGImageAtTime:CMTimeMake(1, 10) actualTime:nil error:nil]]; // 특정 시점의 이미지를 추출
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = self.videoView.bounds;
    [self.videoView addSubview:imageView];

    [self.view addSubview:self.videoView];
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
    [self.playVideoButton addTarget:self action:@selector(playVideoButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupRecordAudioContainerView {
    self.RecordAudioContainerView = [[UIView alloc] initWithFrame:CGRectZero];
    self.RecordAudioContainerView.backgroundColor = [UIColor colorWithRed:0.15 green:0.16 blue:0.17 alpha:1.00];
    self.RecordAudioContainerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.RecordAudioContainerView];
}

- (void)setupRecordButton {
    self.recordButton = [[UIButton alloc] init];
    self.recordButton.frame = CGRectMake(0, 0, 70, 70);
    self.recordButton.backgroundColor = [UIColor redColor];
    self.recordButton.clipsToBounds = YES;
    self.recordButton.layer.cornerRadius = 70/2.0f;
    self.recordButton.layer.borderColor=[UIColor whiteColor].CGColor;
    self.recordButton.layer.borderWidth=2.0f;
    self.recordButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.RecordAudioContainerView addSubview:self.recordButton];
    [self.recordButton addTarget:self action:@selector(recordButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupRemoveAudioButton {
    self.removeAudioButton = [[UIButton alloc] init];
    [self.removeAudioButton setTitle:@"취소" forState:UIControlStateNormal];
    [self.removeAudioButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.removeAudioButton.titleLabel setFont:[UIFont systemFontOfSize:20]];
    self.removeAudioButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.RecordAudioContainerView addSubview:self.removeAudioButton];
    [self.removeAudioButton addTarget:self action:@selector(removeAudioButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)setupCompleteRecordingButton {
    self.completeRecordingButton = [[UIButton alloc] init];
    [self.completeRecordingButton setTitle:@"완료" forState:UIControlStateNormal];
    [self.completeRecordingButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.completeRecordingButton.titleLabel setFont:[UIFont systemFontOfSize:20]];
    self.completeRecordingButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.RecordAudioContainerView addSubview:self.completeRecordingButton];
    [self.completeRecordingButton addTarget:self action:@selector(completeRecordingButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
}


#pragma mark - Setup Constraints Methods

- (void)setupConstraints {
    [self setupVideoViewConstraints];
    [self setupBackToCellectionViewButtonConstraints];
    [self setupPlayVideoButtonConstraints];
    [self setupRecordAudioContainerViewConstraints];
    
    [self setupRecordButtonConstraints];
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

- (void)setupRecordAudioContainerViewConstraints {
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[RecordAudioContainerView]|"
                                             options:0
                                             metrics:nil
                                               views:@{@"RecordAudioContainerView" : self.RecordAudioContainerView}]];
    
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:[RecordAudioContainerView(==200)]|"
                                             options:0
                                             metrics:nil
                                               views:@{@"videoView" : self.videoView, @"RecordAudioContainerView" : self.RecordAudioContainerView}]];
}

- (void) setupRecordButtonConstraints {
    [self.view addConstraint:
     [NSLayoutConstraint constraintWithItem:self.view
                                  attribute:NSLayoutAttributeCenterX
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self.recordButton
                                  attribute:NSLayoutAttributeCenterX
                                 multiplier:1
                                   constant:0]];
    
    [self.view addConstraint:
     [NSLayoutConstraint constraintWithItem:self.RecordAudioContainerView
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
}

- (void) setupRemoveAudioButtonConstraint {
    [self.view addConstraint:
     [NSLayoutConstraint constraintWithItem:self.RecordAudioContainerView
                                  attribute:NSLayoutAttributeCenterY
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self.removeAudioButton
                                  attribute:NSLayoutAttributeCenterY
                                 multiplier:1
                                   constant:0]];
    
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-40-[removeAudioButton]-40-[recordButton]"
                                             options:0
                                             metrics:nil
                                               views:@{@"removeAudioButton" : self.removeAudioButton, @"recordButton" : self.recordButton}]];
}

- (void) setupCompleteRecordingButtonConstraints {
    [self.view addConstraint:
     [NSLayoutConstraint constraintWithItem:self.RecordAudioContainerView
                                  attribute:NSLayoutAttributeCenterY
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self.completeRecordingButton
                                  attribute:NSLayoutAttributeCenterY
                                 multiplier:1
                                   constant:0]];
    
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:[recordButton]-40-[completeRecordingButton]-40-|"
                                             options:0
                                             metrics:nil
                                               views:@{@"completeRecordingButton" : self.completeRecordingButton, @"recordButton" : self.recordButton}]];
}




#pragma mark - Back To Collection View Button Event Handler Methods

- (void)backToCollectionViewButtonClicked:(UIButton *)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}


#pragma mark - Play Video Button Event Handler Methods

- (void)playVideoButtonClicked:(UIButton *)sender {
    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:self.videoURL options:nil];
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:avAsset];
    AVPlayer *player = [AVPlayer playerWithPlayerItem:playerItem];
    
    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:player];
    [playerLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    playerLayer.frame = self.videoView.frame;
    
    [self.videoView.layer addSublayer:playerLayer];
    
    [player play];
}


#pragma mark - Record Audio Button Event Handler Methods

- (void)recordButtonClicked:(UIButton *)sender {
    NSLog(@"Record Audio Button Cliked");
}


#pragma mark - Remove Audio Button Event Handler Methods

- (void)removeAudioButtonClicked:(UIButton *)sender {
    NSLog(@"Remove Audio Button Clicked");
}


#pragma mark - Complete Recording Button Event Handler Methods

- (void)completeRecordingButtonClicked:(UIButton *)sender {
    NSLog(@"Complete Recording Button Clicked");
}

@end
