//
//  WMMediaUtils.m
//  WorksMovie
//
//  Created by Naver on 2016. 8. 3..
//  Copyright © 2016년 worksmobile. All rights reserved.
//

#import "WMMediaUtils.h"
#import <AVFoundation/AVFoundation.h>

@implementation WMMediaUtils

+ (BOOL)isSimulator {
    UIDevice *currentDevice = [UIDevice currentDevice];
    if ([currentDevice.model rangeOfString:@"Simulator"].location == NSNotFound) {
        return YES;
    } else {
        return NO;
    }
}

// 촬영된 비디오로부터 썸네일을 추출하여 추출된 still 이미지를 imageView에 추가한 후 imageView를 반환
+ (UIImageView *)gettingThumbnailFromVideoInView:(UIView *)videoView URL:(NSURL *)url filter:(WMFilter *)filter {
    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:url options:nil]; // 썸네일을 생성하기 위해 첫 번째 비디오의 url을 파라미터를 AVURLAsset에 넣는다.
    AVAssetImageGenerator *imageGenerator = [AVAssetImageGenerator assetImageGeneratorWithAsset:asset];
    [imageGenerator setAppliesPreferredTrackTransform:true];
    UIImage *image = [UIImage imageWithCGImage:[imageGenerator copyCGImageAtTime:CMTimeMake(1, 10) actualTime:nil error:nil]]; // 특정 시점의 이미지를 추출
    CGImageRelease([imageGenerator copyCGImageAtTime:CMTimeMake(1, 10) actualTime:nil error:nil]);
    
    if  (filter != nil) {
        CIImage *ciimage = [[CIImage alloc] initWithImage:image];
        CIFilter *ciFilter = [CIFilter filterWithName: filter.imageName keysAndValues:kCIInputImageKey, ciimage, nil];
        [ciFilter setDefaults];
        
        CIContext *context = [CIContext contextWithOptions:nil];
        CIImage *output = [ciFilter outputImage];
        
        CGImageRef cgimage = [context createCGImage:output fromRect:[output extent]];
        image = [UIImage imageWithCGImage:cgimage scale:0 orientation:[image imageOrientation]];
        
        CGImageRelease(cgimage);
    }
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = videoView.bounds;
    
    return imageView;
}

@end
