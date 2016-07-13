//
//  WMModel.h
//  WorksMovie
//
//  Created by Naver on 2016. 7. 12..
//  Copyright © 2016년 worksmobile. All rights reserved.
//

/**
 * 다양한 동영상 형태에 대한 프로퍼티를 가지고 있는 모델 객체이다.
 * VideoModel과 AudioModel로 realization된다.
 */

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>


@interface WMModel : NSObject

@property (nonatomic, strong) NSURL *videoURL;

@end
