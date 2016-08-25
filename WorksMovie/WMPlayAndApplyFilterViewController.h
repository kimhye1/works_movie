//
//  WMPlayAndApplyFilterViewController.h
//  WorksMovie
//
//  Created by Naver on 2016. 8. 15..
//  Copyright © 2016년 worksmobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WMVideoModelManager.h"

@interface WMPlayAndApplyFilterViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate>

- (instancetype)initWithVideoModelManager:(WMVideoModelManager *)videoManager;
- (void)playVideo:(NSURL *)outputURL;

@end
