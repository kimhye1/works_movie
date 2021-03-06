//
//  WMPlayAndStoreVideoViewController.h
//  WorksMovie
//
//  Created by Naver on 2016. 7. 7..
//  Copyright © 2016년 worksmobile. All rights reserved.
//

/**
 * 촬영한 동영상들을 이어서 재생하고, 로컬에 저장 하는 기능을 제공한다.
 */


#import <UIKit/UIKit.h>
#import "WMVideoModelManager.h"
#import "WMFilter.h"

@interface WMPlayAndStoreVideoViewController : UIViewController

@property (nonatomic, strong) WMFilter *filter;

- (instancetype)initWithVideoModelManager:(WMVideoModelManager *)modelManager
                              composition:(AVVideoComposition *)composition
                                outputURL:(NSURL *)outputURL
                                   filter:(WMFilter *)filter;
- (void)savedAlert;

@end
