//
//  WMPlayVideo.h
//  WorksMovie
//
//  Created by Naver on 2016. 7. 14..
//  Copyright © 2016년 worksmobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "WMVideoModelManager.h"

@interface WMMediaPlayer : NSObject

- (instancetype)initWithVideoModelManager:(WMVideoModelManager *)modelManager;
- (UIImageView *)gettingThumbnailFromVideoInView:(UIView *)videoView withURL:(NSURL *)url;
- (void)preparePlay;
- (void)playVideo:(UIView *)videoView;
- (void)stopPlay;

@end
