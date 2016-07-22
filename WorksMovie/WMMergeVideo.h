//
//  WMMergeVideo.h
//  WorksMovie
//
//  Created by Naver on 2016. 7. 22..
//  Copyright © 2016년 worksmobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WMModelManager.h"

@interface WMMergeVideo : NSObject

- (instancetype)initWithModelManager:(WMModelManager *)modelManager;
- (AVMutableComposition *)mergeVideo;
- (AVAssetExportSession *)exportVideo;


@end
