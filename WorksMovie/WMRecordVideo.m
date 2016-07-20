//
//  WMRecordVideo.m
//  WorksMovie
//
//  Created by Naver on 2016. 7. 14..
//  Copyright © 2016년 worksmobile. All rights reserved.
//

#import "WMRecordVideo.h"
#import "WMModel.h"

@interface WMRecordVideo ()

@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureMovieFileOutput *output;
@property (nonatomic) bool recording; //비디오가 녹화 중 인지를 추적하기 위한 변수

@end

@implementation WMRecordVideo

- (instancetype)init {
    self = [super init];
    
    if(self) {
        self.modelManager = [[WMModelManager alloc] init];
    }
    return self;
}

- (void)setupCaptureSession {
    self.session = [[AVCaptureSession alloc] init];
    self.session.sessionPreset = AVCaptureSessionPresetHigh;
    
    //카메라에 대한 AVCaptureDevice로 인스턴스 생성하고 AVCaptureDeviceInput을 생성한 후 세션에 추가한다.
    AVCaptureDevice *inputDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput *deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:inputDevice error:nil];
    if ([self.session canAddInput:deviceInput]) { //세션에 추가하기 전에 입력이 올바르게 되었는지 확인
        [self.session addInput:deviceInput];
    }
    
    //마이크에 대한 AVCaptureDevice로 인스턴스 생성하고 AVCaptureDeviceInput을 생성한 후 세션에 추가한다.
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeAudio];
    AVCaptureDeviceInput *mic = [[AVCaptureDeviceInput alloc] initWithDevice:[devices objectAtIndex:0] error:nil];
    if ([self.session canAddInput:mic]) {
        [self.session addInput:mic];
    }
    self.output = [[AVCaptureMovieFileOutput alloc] init];
    [self.session addOutput:self.output];
}

- (void)setupPreviewLayerInView:(UIView *)cameraView {
    //앱에서 카메라를 통해 보이는 것을 그대로 보여줄 AVCaptureVideoPreviewLayer 생성
    AVCaptureVideoPreviewLayer *previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
    
    [previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    CGRect frame = cameraView.frame;
    [previewLayer setFrame:frame];
    [cameraView.layer insertSublayer:previewLayer atIndex:0];
    
    [self.session startRunning];
    self.recording = NO;
}

- (void)startRecording {
    self.recording = YES;
        
    WMModel *videoData = [[WMModel alloc] init];
    videoData.videoURL = [self createTempURL];
    [self.output startRecordingToOutputFileURL:videoData.videoURL recordingDelegate:self];
    
    [self.modelManager addvideoData:videoData]; // modelManager의 프로퍼티인 videosURLArray에 촬영된 비디오에 대한 URL 추가
}

//디바이스에 임시 저장된 비디오에 대한 유일한 경로를 반환한다. 이미 파일이 저장되어 있는 경우 그 파일을 삭제한다
- (NSURL *)createTempURL {
    NSString *uuid = [[NSUUID UUID] UUIDString];
    
    NSString *outputPath = [[NSString alloc] initWithFormat:@"%@%@%@", NSTemporaryDirectory(), uuid, @".mov"];
    
    NSURL *outputURL = [[NSURL alloc] initFileURLWithPath:outputPath];
    NSFileManager *manager = [[NSFileManager alloc] init];
    
    if([manager fileExistsAtPath:outputPath]) {
        [manager removeItemAtPath:outputPath error:nil];
    }
    return outputURL;
}


- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error {
}

- (void)stopRecording {
    [self.output stopRecording];
    self.recording = NO;
}

@end
