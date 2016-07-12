//
//  WMModelManager.h
//  WorksMovie
//
//  Created by Naver on 2016. 7. 12..
//  Copyright © 2016년 worksmobile. All rights reserved.
//

/**
 * 동영상 데이터 모델을 컨트롤하는 클래스
 */

#import <Foundation/Foundation.h>

@interface WMModelManager : NSObject

@property (nonatomic, strong) NSMutableArray *videosURLArray;

- (void)addvideoURL:(NSURL *) url;
- (void)removeLastVideoURL;

@end
