//
//  WMMultiMediaRecordProtocol.h
//  WorksMovie
//
//  Created by Naver on 2016. 8. 2..
//  Copyright © 2016년 worksmobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@protocol WMMultiMediaRecordProtocol <NSObject>

@required
- (void)startRecording;
- (void)stopRecording;

@optional
- (void)setupCaptureSession;
- (void)setupPreviewLayerInView:(UIView *)view;
- (void)switchCamera;

@end
