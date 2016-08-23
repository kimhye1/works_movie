//
//  WMRecordVideo.m
//  WorksMovie
//
//  Created by Naver on 2016. 7. 14..
//  Copyright © 2016년 worksmobile. All rights reserved.
//

#import "WMVideoRecorder.h"
#import "WMVideoModel.h"

@interface WMVideoRecorder ()

@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureMovieFileOutput *output;
@property (nonatomic) bool recording; //비디오가 녹화 중 인지를 추적하기 위한 변수
@property (nonatomic, strong) WMVideoModelManager *modelManager;

@end

@implementation WMVideoRecorder

- (instancetype)initWithVideoModelManager:(WMVideoModelManager *)modelManager {
    self = [super init];
    
    if (self) {
        self.modelManager = modelManager;
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
    AVCaptureDeviceInput *mic = [[AVCaptureDeviceInput alloc] initWithDevice:[devices firstObject] error:nil];
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

// 전방 또는 후방 카메라로 카메라 모드 전환
- (void)switchCamera {
    if (!self.session) {
        return;
    }
    
    [self.session beginConfiguration]; // session에 변경이 생길 것이라고 명시
    
    // 현재 존재하는 input중 camera를 제거
    AVCaptureInput *currentInput = nil;
    BOOL didFound = NO;
    
    for (NSInteger index = 0 ; index < self.session.inputs.count ; index ++) {
        currentInput = [self.session.inputs objectAtIndex:index];
        NSArray *inputPorts = currentInput.ports;
        
        for (AVCaptureInputPort *port in inputPorts) {
            if (port.mediaType == AVMediaTypeVideo) {
                didFound = YES;
                break;
            }
        }
        if (didFound) break;
    }
    
    if (!currentInput) {
        NSLog(@"발견된 camera 없음.");
        return;
    }
    
    [self.session removeInput:currentInput];
    
    if (((AVCaptureDeviceInput *)currentInput).device.position == AVCaptureDevicePositionUnspecified) {
        NSLog(@"The capture device’s position relative to the system hardware is unspecified.");
    }
    
    // 새로운 input device 생성
    AVCaptureDevice *newInputDevice = nil;
    if (((AVCaptureDeviceInput *)currentInput).device.position == AVCaptureDevicePositionBack) {
        newInputDevice = [self cameraWithPosition:AVCaptureDevicePositionFront];
    } else {
        newInputDevice = [self cameraWithPosition:AVCaptureDevicePositionBack];
    }
    
    NSError *err = nil;
    AVCaptureDeviceInput *newDeviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:newInputDevice error:&err];
    if (!newDeviceInput || err) {
        NSLog(@"Error creating capture device input: %@", err.localizedDescription);
    } else {
        [self.session addInput:newDeviceInput]; // input을 session에 추가
    }
    [self.session commitConfiguration]; // 모든 변경 사항을 session에 commit 시킨다.
}

// AVCaptureDevicePosition을 찾아서 반환. device를 발견하지 못하면 nil을 반환
- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition)position {
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices) {
        if ([device position] == position) return device;
    }
    return nil;
}

- (void)startRecording {
    self.recording = YES;
        
    WMVideoModel *videoData = [[WMVideoModel alloc] init];
    videoData.mediaURL = [self createTempURL];
    [self.output startRecordingToOutputFileURL:videoData.mediaURL recordingDelegate:self];
    
    [self.modelManager addMediaData:videoData]; // modelManager의 프로퍼티인 videosURLArray에 촬영된 비디오에 대한 URL 추가
}

//디바이스에 임시 저장된 비디오에 대한 유일한 경로를 반환한다. 이미 파일이 저장되어 있는 경우 그 파일을 삭제한다
- (NSURL *)createTempURL {
    NSString *uuid = [[NSUUID UUID] UUIDString];
    
    NSString *outputPath = [[NSString alloc] initWithFormat:@"%@%@%@", NSTemporaryDirectory(), uuid, @".mov"];
    
    NSURL *outputURL = [[NSURL alloc] initFileURLWithPath:outputPath];
    NSFileManager *manager = [[NSFileManager alloc] init];
    
    if ([manager fileExistsAtPath:outputPath]) {
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

- (void)stopSession {
    [self.session stopRunning];
}

- (void)startSession {
    [self.session startRunning];
}

@end
