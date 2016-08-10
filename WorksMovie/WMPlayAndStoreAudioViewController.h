//
//  WMPlayAndStoreAudioViewController.h
//  WorksMovie
//
//  Created by Naver on 2016. 8. 1..
//  Copyright © 2016년 worksmobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WMAudioModelManager.h"
#import "WMVideoModelManager.h"

@interface WMPlayAndStoreAudioViewController : UIViewController

- (instancetype)initWithVideoModelManager:(WMVideoModelManager *)videoModelManager audioModelManager:(WMAudioModelManager *)audioModelManager;

@end
