//
//  WMMediaModelManager.h
//  WorksMovie
//
//  Created by Naver on 2016. 7. 12..
//  Copyright © 2016년 worksmobile. All rights reserved.
//

/**
 * 동영상 데이터 모델을 컨트롤하는 클래스
 */

#import <Foundation/Foundation.h>
#import "WMMediaModel.h"

@interface WMMediaModelManager : NSObject

@property (nonatomic, strong) NSMutableArray *mediaDatas;

- (void)addMediaData:(WMMediaModel *)mediaData;
- (void)removeLastMedia;
- (void)removeObjectAtIndex:(NSUInteger)index;

@end
