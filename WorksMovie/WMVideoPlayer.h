//
//  WMPlayVideo.h
//  WorksMovie
//
//  Created by Naver on 2016. 7. 14..
//  Copyright © 2016년 worksmobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "WMModelManager.h"

@interface WMVideoPlayer : NSObject

- (instancetype)initWithModelManager:(WMModelManager *)modelManager;
- (UIImageView *)gettingThumbnailFromVideoInView:(UIView *)videoView;
- (void)playVideo:(UIView *)videoView;

@end
