//
//  WMStoreVideo.h
//  WorksMovie
//
//  Created by Naver on 2016. 7. 14..
//  Copyright © 2016년 worksmobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WMModelManager.h"

@interface WMStoreVideo : NSObject

- (instancetype)initWithModelManager:(WMModelManager *)modelManager;
- (void)mergeVideo;
- (void)storeVideo;

@end
