//
//  WMShootingVideoViewController.m
//  WorksMovie
//
//  Created by Naver on 2016. 6. 29..
//  Copyright © 2016년 worksmobile. All rights reserved.
//

#import "WMShootingVideoViewController.h"
#import "WMPlayAndStoreVideoViewController.h"
#import "WMModelManager.h"
#import "WMRecordVideo.h"

@interface WMShootingVideoViewController ()

@property (nonatomic, strong) WMRecordVideo *recordVideo;
@property (nonatomic, strong) WMModelManager *modelManager;
@property (nonatomic, strong) UIView *cameraView;
@property (nonatomic, strong) UIView *videoShootingMenuContainerView;
@property (nonatomic, strong) UIButton *shootingButton;
@property (nonatomic, strong) UIButton *removeVideoButton;
@property (nonatomic, strong) UIButton *completeShootingButton;
@property (nonatomic, strong) UIImageView *recordingStateMark;



@end

@implementation WMShootingVideoViewController

- (instancetype)init {
    self = [super init];
    
    if(self) {
        self.recordVideo = [[WMRecordVideo alloc] init];
        self.modelManager = [[WMModelManager alloc] init];
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
    [self setupCameraView];
    [self setupVideoShootingMenuContainerView];
    [self setupShootingButton];
    [self setupRemoveVideoButton];
    [self setupCompleteShootingButton];
    [self setupRecordingStateMark];
}

- (void)setupCameraView {
    self.cameraView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-200)];
    self.cameraView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.cameraView];
    
}

- (void)setupVideoShootingMenuContainerView {
    self.videoShootingMenuContainerView = [[UIView alloc] initWithFrame:CGRectZero];
    self.videoShootingMenuContainerView.backgroundColor = [UIColor colorWithRed:0.15 green:0.16 blue:0.17 alpha:1.00];
    self.videoShootingMenuContainerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.videoShootingMenuContainerView];
}

- (void)setupShootingButton {
    self.shootingButton = [[UIButton alloc] init];
    self.shootingButton.frame = CGRectMake(0, 0, 70, 70);
    self.shootingButton.backgroundColor = [UIColor redColor];
    self.shootingButton.clipsToBounds = YES;
    self.shootingButton.layer.cornerRadius = 70/2.0f;
    self.shootingButton.layer.borderColor=[UIColor whiteColor].CGColor;
    self.shootingButton.layer.borderWidth=2.0f;
    self.shootingButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.videoShootingMenuContainerView addSubview:self.shootingButton];
    
    UILongPressGestureRecognizer *shootingButtonPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(shootingButtonLongPress:)];
    [self.shootingButton addGestureRecognizer:shootingButtonPressRecognizer];

}

- (void)setupRemoveVideoButton {
    self.removeVideoButton = [[UIButton alloc] init];
    [self.removeVideoButton setImage:[UIImage imageNamed:@"Delete1"] forState:UIControlStateNormal];
    self.removeVideoButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.videoShootingMenuContainerView addSubview:self.removeVideoButton];
    [self.removeVideoButton addTarget:self action:@selector(removeVideoButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)setupCompleteShootingButton {
    self.completeShootingButton = [[UIButton alloc] init];
    [self.completeShootingButton
     setImage:[UIImage imageNamed:@"Checkmark1"] forState:UIControlStateNormal];
    self.completeShootingButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.videoShootingMenuContainerView addSubview:self.completeShootingButton];
    [self.completeShootingButton addTarget:self action:@selector(completeShootingButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupRecordingStateMark {
    self.recordingStateMark = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"recordMark"]];
    self.recordingStateMark.translatesAutoresizingMaskIntoConstraints = NO;
    self.recordingStateMark.hidden = YES;
    [self.cameraView addSubview:self.recordingStateMark];
}


#pragma mark - Setup Constraints Methods

- (void)setupConstraints {
    [self setupVideoShootingMenuContainerViewConstraints];
    [self setupShootingButtonConstraints];
    [self setupRemoveVideoButtonConstraint];
    [self setupCompleteShootingButtonConstraints];
    [self setupRecordingStateMarkConstraints];
}

- (void) setupVideoShootingMenuContainerViewConstraints {
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[videoShootingMenuContainerView]|"
                                             options:0
                                             metrics:nil
                                               views:@{@"videoShootingMenuContainerView" : self.videoShootingMenuContainerView}]];
    
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:[videoShootingMenuContainerView(==200)]|"
                                             options:0
                                             metrics:nil
                                               views:@{@"cameraView" : self.cameraView, @"videoShootingMenuContainerView" : self.videoShootingMenuContainerView}]];
}

- (void) setupShootingButtonConstraints {
    [self.view addConstraint:
     [NSLayoutConstraint constraintWithItem:self.view
                                  attribute:NSLayoutAttributeCenterX
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self.shootingButton
                                  attribute:NSLayoutAttributeCenterX
                                 multiplier:1
                                   constant:0]];
    
    [self.view addConstraint:
     [NSLayoutConstraint constraintWithItem:self.videoShootingMenuContainerView
                                  attribute:NSLayoutAttributeCenterY
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self.shootingButton
                                  attribute:NSLayoutAttributeCenterY
                                 multiplier:1
                                   constant:0]];
    
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:[shootingButton(==70)]"
                                             options:0
                                             metrics:nil
                                               views:@{@"shootingButton" : self.shootingButton}]];
    
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:[shootingButton(==70)]"
                                             options:0
                                             metrics:nil
                                               views:@{@"shootingButton" : self.shootingButton}]];
}

- (void) setupRemoveVideoButtonConstraint {
    [self.view addConstraint:
     [NSLayoutConstraint constraintWithItem:self.videoShootingMenuContainerView
                                  attribute:NSLayoutAttributeCenterY
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self.removeVideoButton
                                  attribute:NSLayoutAttributeCenterY
                                 multiplier:1
                                   constant:0]];
    
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-40-[removeVideoButton]-40-[shootingButton]"
                                             options:0
                                             metrics:nil
                                               views:@{@"removeVideoButton" : self.removeVideoButton, @"shootingButton" : self.shootingButton}]];
}

- (void) setupCompleteShootingButtonConstraints {
    [self.view addConstraint:
     [NSLayoutConstraint constraintWithItem:self.videoShootingMenuContainerView
                                  attribute:NSLayoutAttributeCenterY
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self.completeShootingButton
                                  attribute:NSLayoutAttributeCenterY
                                 multiplier:1
                                   constant:0]];
    
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:[shootingButton]-40-[completeShootingButton]-40-|"
                                             options:0
                                             metrics:nil
                                               views:@{@"completeShootingButton" : self.completeShootingButton, @"shootingButton" : self.shootingButton}]];
}

- (void)setupRecordingStateMarkConstraints {
    [self.cameraView addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[recordingStateMark(==40)]"
                                             options:0
                                             metrics:nil
                                               views:@{@"recordingStateMark" : self.recordingStateMark}]];
    
    [self.cameraView addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[recordingStateMark(==40)]"
                                             options:0
                                             metrics:nil
                                               views:@{@"recordingStateMark" : self.recordingStateMark}]];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.recordVideo setupCaptureSession];
    [self.recordVideo setupPreviewLayerInView:self.cameraView];
}


#pragma mark - Shooting Button Event Handler Methods

//shootingButton을 long tap할 때 마다 tap 하는 시간 동안 동영상이 녹화되고, button에서 손을 떼면 녹화가 종료된다.
- (void)shootingButtonLongPress:(UILongPressGestureRecognizer*)gesture {
    if (gesture.state == UIGestureRecognizerStateBegan) {
        [self.recordVideo startRecording];
        self.recordingStateMark.hidden = NO;
    }
    
    if (gesture.state == UIGestureRecognizerStateEnded) {
        [self.recordVideo stopRecording];
        self.recordingStateMark.hidden = YES;
    }
}


#pragma mark - Complete Shooting Button Event Handler Methods

- (void)completeShootingButtonClicked:(UIButton *)sender {
    [self presentWMPlayAndStoreVideoViewController];
}

- (void)presentWMPlayAndStoreVideoViewController {
    WMPlayAndStoreVideoViewController *playAndStoreVideoVeiwController =
    [[WMPlayAndStoreVideoViewController alloc] initWithVideoModelManager:self.recordVideo.modelManager];
    [self presentViewController:playAndStoreVideoVeiwController animated:YES completion:nil];
}


#pragma mark - Remove Video Button Event Handler Methods

- (void)removeVideoButtonClicked:(UIButton *)sender {
    [self.recordVideo.modelManager removeLastVideo];
}

@end
