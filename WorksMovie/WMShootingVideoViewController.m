//
//  WMShootingVideoViewController.m
//  WorksMovie
//
//  Created by Naver on 2016. 6. 29..
//  Copyright © 2016년 worksmobile. All rights reserved.
//

#import "WMShootingVideoViewController.h"
#import "WMPlayAndApplyFilterViewController.h"
#import "WMVideoModelManager.h"
#import "WMVideoHelper.h"
#import "DALabeledCircularProgressView.h"
#import "WMEditVideoViewController.h"
#import "WMNotificationStrings.h"
#import "WMMediaUtils.h"

@interface WMShootingVideoViewController ()

@property (nonatomic, strong) WMVideoHelper *videoHelper;
@property (nonatomic, strong) WMVideoModelManager *modelManager;
@property (nonatomic, strong) UIView *cameraView;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *switchCameraButton;
@property (nonatomic, strong) UIView *videoShootingMenuContainerView;
@property (nonatomic, strong) UIButton *removeVideoButton;
@property (nonatomic, strong) UIButton *completeShootingButton;
@property (nonatomic, strong) UIImageView *recordingStateMark;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSTimer *countDownTimer;
@property (nonatomic) BOOL isRecording;

@end

@implementation WMShootingVideoViewController

- (instancetype)init {
    self = [super init];
    
    if (self) {
        self.modelManager = [[WMVideoModelManager alloc] init];
        self.videoHelper = [[WMVideoHelper alloc] initWithVideoModelManager:self.modelManager];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupViewComponents];
    [self setupConstraints];
    
    [self prepareRecording];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillResignActive:)
                                                 name:UIApplicationWillResignActiveNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appDidBecomeActive:)
                                                 name:UIApplicationDidBecomeActiveNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appDidBecomeActiveWhenDismissed:)
                                                 name:WMEditVideoViewControllerDidDismissedNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [self checkDevice];
}


#pragma mark - Create Views Methods

- (void)setupViewComponents {
    [self setupCameraView];
    [self setupSwitchCameraButton];
    [self setupBackButton];
    [self setupVideoShootingMenuContainerView];
    [self setupRecordingStateMark]; 
}

- (void)setupCameraView {
    self.cameraView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-170)];
    self.cameraView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.cameraView];
}

- (void)setupSwitchCameraButton {
    self.switchCameraButton = [[UIButton alloc] init];
    [self.switchCameraButton setImage:[UIImage imageNamed:@"switchCameraButton"] forState:UIControlStateNormal];
    self.switchCameraButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.cameraView addSubview:self.switchCameraButton];
    [self.switchCameraButton addTarget:self action:@selector(switchCameraButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupBackButton {
    self.backButton = [[UIButton alloc] init];
    [self.backButton setImage:[UIImage imageNamed:@"backButton"] forState:UIControlStateNormal];
    self.backButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.cameraView addSubview:self.backButton];
    [self.backButton addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupVideoShootingMenuContainerView {
    self.videoShootingMenuContainerView = [[UIView alloc] initWithFrame:CGRectZero];
    self.videoShootingMenuContainerView.backgroundColor = [UIColor colorWithRed:0.15 green:0.16 blue:0.17 alpha:1.00];
    self.videoShootingMenuContainerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.videoShootingMenuContainerView];
    
    [self setupShootingButton];
    [self setupRemoveVideoButton];
    [self setupCompleteShootingButton];
}

- (void)setupShootingButton {
    self.shootingButton = [[DACircularProgressView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    self.shootingButton.roundedCorners = YES;
    self.shootingButton.trackTintColor = [UIColor darkGrayColor];
    self.shootingButton.progressTintColor = [UIColor greenColor];
    self.shootingButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.videoShootingMenuContainerView addSubview:self.shootingButton];
    
    self.recordingTimeCounter = [[UILabel alloc] init];
    self.recordingTimeCounter.text = @"30";
    self.recordingTimeCounter.textColor = [UIColor whiteColor];
    self.recordingTimeCounter.textAlignment = NSTextAlignmentCenter;
    [self.recordingTimeCounter setFont:[UIFont systemFontOfSize:40]];
    self.recordingTimeCounter.translatesAutoresizingMaskIntoConstraints = NO;
    [self.shootingButton addSubview:self.recordingTimeCounter];
    self.time = 30;
    
    UILongPressGestureRecognizer *shootingButtonPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(shootingButtonLongPress:)];
    [self.shootingButton addGestureRecognizer:shootingButtonPressRecognizer];
}

- (void)setupRemoveVideoButton {
    self.removeVideoButton = [[UIButton alloc] init];
    [self.removeVideoButton setImage:[UIImage imageNamed:@"Delete1"] forState:UIControlStateNormal];
    self.removeVideoButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
    self.removeVideoButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.videoShootingMenuContainerView addSubview:self.removeVideoButton];
    [self.removeVideoButton addTarget:self action:@selector(removeVideoButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)setupCompleteShootingButton {
    self.completeShootingButton = [[UIButton alloc] init];
    [self.completeShootingButton
     setImage:[UIImage imageNamed:@"Checkmark1"] forState:UIControlStateNormal];
    self.completeShootingButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
    self.completeShootingButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.completeShootingButton.hidden = YES;
    [self.videoShootingMenuContainerView addSubview:self.completeShootingButton];
    [self.completeShootingButton addTarget:self action:@selector(completeShootingButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupRecordingStateMark {
    self.recordingStateMark = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"recordMark"]];
    self.recordingStateMark.translatesAutoresizingMaskIntoConstraints = NO;
    self.recordingStateMark.hidden = YES;
    [self.cameraView addSubview:self.recordingStateMark];
}

- (void)prepareRecording {
    [self.videoHelper setupCaptureSession];
    [self.videoHelper setupPreviewLayerInView:self.cameraView];
    
    self.progressArray = [[NSMutableArray alloc] init];
    self.countOutTimeArray = [[NSMutableArray alloc] init];
}


#pragma mark - Setup Constraints Methods

- (void)setupConstraints {
    [self setupCameraViewConstraints];
    [self setupSwitchCameraButtonConstraints];
    [self setupBackButtonConstrains];
    [self setupVideoShootingMenuContainerViewConstraints];
    [self setupRecordingStateMarkConstraints];
}

- (void)setupCameraViewConstraints {
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[cameraView]|"
                                             options:0
                                             metrics:nil
                                               views:@{@"cameraView" : self.cameraView}]];
    
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[cameraView]-170-|"
                                             options:0
                                             metrics:nil
                                               views:@{@"cameraView" : self.cameraView}]];
}

- (void)setupSwitchCameraButtonConstraints {
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:[switchCameraButton(==35)]-20-|"
                                             options:0
                                             metrics:nil
                                               views:@{@"switchCameraButton" : self.switchCameraButton}]];
    
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-15-[switchCameraButton(==35)]"
                                             options:0
                                             metrics:nil
                                               views:@{@"switchCameraButton" : self.switchCameraButton}]];
    
}

- (void)setupBackButtonConstrains {
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[backButton(==40)]"
                                             options:0
                                             metrics:nil
                                               views:@{@"backButton" : self.backButton}]];
    
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[backButton(==40)]"
                                             options:0
                                             metrics:nil
                                               views:@{@"backButton" : self.backButton}]];
}

- (void)setupVideoShootingMenuContainerViewConstraints {
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[videoShootingMenuContainerView]|"
                                             options:0
                                             metrics:nil
                                               views:@{@"videoShootingMenuContainerView" : self.videoShootingMenuContainerView}]];
    
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:[videoShootingMenuContainerView(==170)]|"
                                             options:0
                                             metrics:nil
                                               views:@{@"cameraView" : self.cameraView, @"videoShootingMenuContainerView" : self.videoShootingMenuContainerView}]];

    [self setupShootingButtonConstraints];
    [self setupRemoveVideoButtonConstraint];
    [self setupCompleteShootingButtonConstraints];
}

- (void)setupShootingButtonConstraints {
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
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:[shootingButton(==120)]"
                                             options:0
                                             metrics:nil
                                               views:@{@"shootingButton" : self.shootingButton}]];
    
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:[shootingButton(==120)]"
                                             options:0
                                             metrics:nil
                                               views:@{@"shootingButton" : self.shootingButton}]];
    
    
    [self.view addConstraint:
     [NSLayoutConstraint constraintWithItem:self.shootingButton
                                  attribute:NSLayoutAttributeCenterX
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self.recordingTimeCounter
                                  attribute:NSLayoutAttributeCenterX
                                 multiplier:1
                                   constant:0]];
    
    [self.view addConstraint:
     [NSLayoutConstraint constraintWithItem:self.shootingButton
                                  attribute:NSLayoutAttributeCenterY
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self.recordingTimeCounter
                                  attribute:NSLayoutAttributeCenterY
                                 multiplier:1
                                   constant:0]];
    
}

- (void)setupRemoveVideoButtonConstraint {
    [self.view addConstraint:
     [NSLayoutConstraint constraintWithItem:self.videoShootingMenuContainerView
                                  attribute:NSLayoutAttributeCenterY
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self.removeVideoButton
                                  attribute:NSLayoutAttributeCenterY
                                 multiplier:1
                                   constant:0]];
    
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-31-[removeVideoButton]-31-[shootingButton]-32-[completeShootingButton]-32-|"
                                             options:0
                                             metrics:nil
                                               views:@{@"removeVideoButton" : self.removeVideoButton, @"shootingButton" : self.shootingButton, @"completeShootingButton" : self.completeShootingButton}]];
    
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:[removeVideoButton(==38)]"
                                             options:0
                                             metrics:nil
                                               views:@{@"removeVideoButton" : self.removeVideoButton}]];

}

- (void)setupCompleteShootingButtonConstraints {
    [self.view addConstraint:
     [NSLayoutConstraint constraintWithItem:self.videoShootingMenuContainerView
                                  attribute:NSLayoutAttributeCenterY
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self.completeShootingButton
                                  attribute:NSLayoutAttributeCenterY
                                 multiplier:1
                                   constant:0]];
    
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:[completeShootingButton(==38)]"
                                             options:0
                                             metrics:nil
                                               views:@{@"completeShootingButton" : self.completeShootingButton}]];
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


- (void)checkDevice {
    if([WMMediaUtils isSimulator]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"현재 기기에서는 동영상 촬영을 지원하지 않습니다."
                                                                       message:nil
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *ok = [UIAlertAction
                             actionWithTitle:@"확인"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction *action) {
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
        
        [alert addAction:ok];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
}


#pragma mark - Switch Camera Button Event Handler Methods

- (void)switchCameraButtonClicked:(UIButton *)sender {
    [self.videoHelper switchCamera];
}


#pragma mark - Back Button Event Handler Methods

- (void)backButtonClicked:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:WMShootingVideoViewControllerDidDismissedNotification object:nil];
}


#pragma mark - Shooting Button Event Handler Methods

//shootingButton을 long tap할 때 마다 tap 하는 시간 동안 동영상이 녹화되고, button에서 손을 떼면 녹화가 종료된다.
- (void)shootingButtonLongPress:(UILongPressGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateBegan) {
        self.completeShootingButton.hidden = NO;
        
        self.isRecording = YES;
        
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.01
                                                      target:self
                                                    selector:@selector(updateProgressing)
                                                    userInfo:nil
                                                     repeats:YES]; // 0.01마다 updateProgressing 호출

        
        
        self.countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1
                                                          target:self
                                                        selector:@selector(countdownProgressing)
                                                        userInfo:nil
                                                         repeats:YES]; // 1초마다 countdownProgressing 호출
        
        [self.videoHelper startRecording];
        self.backButton.hidden = YES;
        self.recordingStateMark.hidden = NO;
    }
    
    if (gesture.state == UIGestureRecognizerStateEnded) {
        self.isRecording = NO;
        
        float allProcessValue;
        
        for (NSNumber *progressNum in self.progressArray) {
            allProcessValue += [progressNum floatValue];
        }
        
        [self.progressArray addObject:[NSNumber numberWithDouble:self.shootingButton.progress - allProcessValue]];
        
        [self.countOutTimeArray addObject:[NSNumber numberWithInt:self.countOutTime]];
        self.countOutTime = 0;

        [self.videoHelper stopRecording];
        self.backButton.hidden = NO;
        self.recordingStateMark.hidden = YES;
        
        [self.timer invalidate]; //progressing을 멈춘다.
        [self.countDownTimer invalidate]; // progressing을 멈춘다.
    }
}

- (void)stopRecording {
    self.isRecording = NO;
    
    float allProcessValue;
    
    for (NSNumber *progressNum in self.progressArray) {
        allProcessValue += [progressNum floatValue];
    }
    
    [self.progressArray addObject:[NSNumber numberWithDouble:self.shootingButton.progress - allProcessValue]];
    
    [self.countOutTimeArray addObject:[NSNumber numberWithInt:self.countOutTime]];
    self.countOutTime = 0;
    
    [self.videoHelper stopRecording];
    self.backButton.hidden = NO;
    self.recordingStateMark.hidden = YES;
    
    [self.timer invalidate]; //progressing을 멈춘다.
    [self.countDownTimer invalidate]; // progressing을 멈춘다.
}

// circular progress bar 상태를 업데이트 시킨다.
- (void)updateProgressing {
    double videoRunningTime = 30;
    double eachProgress = 0.01 / videoRunningTime;
    
    self.shootingButton.progress += eachProgress;
    
}

// time 값이 0이 될 때 까지 초 단위로 카운트 다운 한다.
- (void)countdownProgressing {
    if (self.time > 0) {
        self.time--;
        self.recordingTimeCounter.text = [NSString stringWithFormat:@"%d", self.time];
        self.countOutTime++;
    }
}


#pragma mark - Complete Shooting Button Event Handler Methods

- (void)completeShootingButtonClicked:(UIButton *)sender {
    [self.videoHelper stopSession];
    
    [self presentWMEditVideoViewController];
}

- (void)presentWMEditVideoViewController {
    WMEditVideoViewController *editVideoViewController =
    [[WMEditVideoViewController alloc] initWithVideoModelManager:self.modelManager shootingVideoViewController:self];
    [self presentViewController:editVideoViewController animated:YES completion:nil];
}


#pragma mark - Remove Video Button Event Handler Methods

- (void)removeVideoButtonClicked:(UIButton *)sender {
    [self.modelManager removeLastMedia];
    
    // progress bar 업데이트
    double result = self.shootingButton.progress - [[self.progressArray lastObject] floatValue];
    if (result < 0) {
        self.shootingButton.progress = 0;
    } else {
        self.shootingButton.progress -= [[self.progressArray lastObject] floatValue];

    }
    
    // count 업데이트
    self.time += [[self.countOutTimeArray lastObject] intValue];
    [self.countOutTimeArray removeLastObject];
    self.recordingTimeCounter.text = [NSString stringWithFormat:@"%d", self.time];
    self.countOutTime = 0;
    
    [self.progressArray removeLastObject];
}



#pragma mark - Notificatioin Handler Methods

- (void)applicationWillResignActive:(NSNotification *)notification {
    [self.videoHelper stopSession];
    
    if(self.isRecording) {
        [self stopRecording];
    }
}

- (void)appDidBecomeActive:(NSNotification *)notification {
    [self.videoHelper startSession];
}

- (void)appDidBecomeActiveWhenDismissed:(NSNotification *)notice {
    [self.videoHelper startSession];
}

@end
