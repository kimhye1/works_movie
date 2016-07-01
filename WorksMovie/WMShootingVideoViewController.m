//
//  WMShootingVideoViewController.m
//  WorksMovie
//
//  Created by Naver on 2016. 6. 29..
//  Copyright © 2016년 worksmobile. All rights reserved.
//

#import "WMShootingVideoViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface WMShootingVideoViewController ()

@property (nonatomic, strong) UIView *cameraView;
@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureStillImageOutput *stillImageOutput;
@property (nonatomic, strong) UIButton *shootingButton;

@end

@implementation WMShootingVideoViewController

- (instancetype)init {
    self = [super init];
    
    if(self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupComponents];
    [self setupConstraints];

}

- (void)setupComponents {
    self.cameraView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.cameraView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.cameraView];
    
    self.shootingButton = [[UIButton alloc] init];
    [self.shootingButton setTitle:@"촬영하기" forState:UIControlStateNormal];
    self.shootingButton.backgroundColor = [UIColor blueColor];
    self.shootingButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.cameraView addSubview:self.shootingButton];
    [self.shootingButton addTarget:self action:@selector(shootingButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)setupConstraints {
    [self.view addConstraint:
     [NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.shootingButton attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:[shootingButton(==100)]" options:0 metrics:nil views:@{@"shootingButton" : self.shootingButton}]];
    
    [NSLayoutConstraint constraintWithItem:self.shootingButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:[shootingButton(==50)]" options:0 metrics:nil views:@{@"shootingButton" : self.shootingButton}]];
}


- (void)viewWillAppear:(BOOL)animated {
    self.session = [[AVCaptureSession alloc] init];
    [self.session setSessionPreset:AVCaptureSessionPresetPhoto];
    
    AVCaptureDevice *inputDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput *deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:inputDevice error:nil];
    
    if ([self.session canAddInput:deviceInput]) { //세션에 추가하기 전에 확인
        [self.session addInput:deviceInput];
    }
    AVCaptureVideoPreviewLayer *previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
    
    [previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    CALayer *rootLayer = [[self view] layer];
    [rootLayer setMasksToBounds:YES];
    CGRect frame = self.cameraView.frame;
    
    [previewLayer setFrame:frame];
    
    [rootLayer insertSublayer:previewLayer atIndex:0];
    
    self.stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG, AVVideoCodecKey, nil];
    [self.stillImageOutput setOutputSettings:outputSettings];
    
    [self.session addOutput:self.stillImageOutput];
    
    [self.session startRunning];
}

- (void)shootingButtonClicked:(UIButton *)sender {
//    AVCaptureConnection *videoConnection = nil;
//    
//    for (AVCaptureConnection *connection in stillImageOutput.connections) {
//        for (AVCaptureInputPort *port in [connection inputPorts]) {
//            if([[port mediaType] isEqual:AVMediaTypeVideo]) {
//                videoConnection = connection;
//                break;
//            }
//        }
//        if (videoConnection) {
//            break;
//        }
//    }
//    [stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
//        if(imageDataSampleBuffer != NULL) {
//            NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
//            UIImage *image = [UIImage imageWithData:imageData];
//            self.imageView.image = image;
//        }
//    }];
}


@end
