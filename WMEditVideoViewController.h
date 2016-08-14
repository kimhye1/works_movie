//
//  WMEditVideoViewController.h
//  WorksMovie
//
//  Created by Naver on 2016. 8. 12..
//  Copyright © 2016년 worksmobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WMModelManager.h"
#import "WMShootingVideoViewController.h"

@interface WMEditVideoViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate>

- (instancetype)initWithVideoModelManager:(WMModelManager *)videoManager shootingVideoViewController:(WMShootingVideoViewController *)shootingVideoViewController;

@end
