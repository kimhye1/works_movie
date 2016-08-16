//
//  WMAudioSaver.h
//  WorksMovie
//
//  Created by Naver on 2016. 8. 2..
//  Copyright © 2016년 worksmobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WMVideoModelManager.h"
#import "WMAudioModelManager.h"

@interface WMAudioSaver : NSObject

- (instancetype)initWithVideoModelManager:(WMVideoModelManager *)modelManager audioModelManager:(WMAudioModelManager *)audioModelManager;
- (AVMutableComposition *)mergeAudio:(NSURL *)audioURL withVideo:(NSURL *)videoURL;
- (NSURL *)storeVideo:(AVMutableComposition *)composition;

@end
