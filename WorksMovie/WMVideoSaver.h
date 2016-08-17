//
//  WMStoreVideo.h
//  WorksMovie
//
//  Created by Naver on 2016. 7. 14..
//  Copyright © 2016년 worksmobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WMVideoModelManager.h"

@interface WMVideoSaver : NSObject

- (instancetype)initWithVideoModelManager:(WMVideoModelManager *)modelManager;
- (void)mergeVideo;
- (NSURL *)storeVideo;

@end
