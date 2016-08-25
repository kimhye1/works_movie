//
//  WMStoreVideo.h
//  WorksMovie
//
//  Created by Naver on 2016. 7. 14..
//  Copyright © 2016년 worksmobile. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WMVideoModelManager;

@interface WMVideoSaver : NSObject

- (instancetype)initWithVideoModelManager:(WMVideoModelManager *)modelManager;

- (AVMutableComposition *)mergeVideo;
- (NSURL *)storeVideo:(AVVideoComposition *)videoComposition outputURL:(NSURL *)outputURL alertLabel:(UILabel *)saveAlertLabel;

@end
