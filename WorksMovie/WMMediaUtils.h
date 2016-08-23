//
//  WMMediaUtils.h
//  WorksMovie
//
//  Created by Naver on 2016. 8. 3..
//  Copyright © 2016년 worksmobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WMFilter.h"

@interface WMMediaUtils : NSObject

+ (BOOL)isSimulator;
+ (UIImageView *)gettingThumbnailFromVideoInView:(UIView *)videoView URL:(NSURL *)url filter:(WMFilter *)filter;

@end
