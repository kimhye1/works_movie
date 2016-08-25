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
#import "WMFilter.h"

@interface WMPlayAndStoreAudioViewController : UIViewController

@property (nonatomic, strong) WMFilter *filter;

//- (instancetype)initWithVideoModelManager:(WMVideoModelManager *)videoModelManager audioModelManager:(WMAudioModelManager *)audioModelManager;

- (instancetype)initWithVideoModelManager:(WMVideoModelManager *)videoModelManager
                        audioModelManager:(WMAudioModelManager *)audioModelManager
                              composition:(AVVideoComposition *)composition
                                   filter:(WMFilter *)filter;


@end
