//
//  WMPlayAndApplyFilterOnStoredVideoViewController.h
//  WorksMovie
//
//  Created by Naver on 2016. 8. 25..
//  Copyright © 2016년 worksmobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WMAudioModelManager.h"
#import "WMVideoModelManager.h"

@interface WMPlayAndApplyFilterOnStoredVideoViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate>

- (instancetype)initWithVideoModelManager:(WMVideoModelManager *)videoModelManager audioModelManager:(WMAudioModelManager *)audioModelManager;
- (void)playVideo;

@end
