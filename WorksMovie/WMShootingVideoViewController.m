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
@property (nonatomic, strong) UIButton *shootingButton;

@end

@implementation WMShootingVideoViewController

//AVCaptureSession *session;
AVCaptureStillImageOutput *stillImageOutput;

- (instancetype)init {
    self = [super init];
    
    if(self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupComponents];

}

- (void)setupComponents {
    self.cameraView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.cameraView.translatesAutoresizingMaskIntoConstraints = NO;

    [self.view addSubview:self.cameraView];
    
    self.shootingButton = [[UIButton alloc] init];
    
}


- (void)viewWillAppear:(BOOL)animated {
    AVCaptureSession *session = [[AVCaptureSession alloc] init];
    [session setSessionPreset:AVCaptureSessionPresetPhoto];
    
    AVCaptureDevice *inputDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput *deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:inputDevice error:nil];
    
    if ([session canAddInput:deviceInput]) {
        [session addInput:deviceInput];
    }
    AVCaptureVideoPreviewLayer *previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:session];
    
    [previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    CALayer *rootLayer = [[self view] layer];
    [rootLayer setMasksToBounds:YES];
    CGRect frame = self.cameraView.frame;
    
    [previewLayer setFrame:frame];
    
    [rootLayer insertSublayer:previewLayer atIndex:0];
    
    stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG, AVVideoCodecKey, nil];
    [stillImageOutput setOutputSettings:outputSettings];
    
    [session addOutput:stillImageOutput];
    
    [session startRunning];
}



@end
