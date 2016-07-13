//
//  WMModelManager.m
//  WorksMovie
//
//  Created by Naver on 2016. 7. 12..
//  Copyright © 2016년 worksmobile. All rights reserved.
//

#import "WMModelManager.h"

@implementation WMModelManager

- (instancetype)init {
    self = [super init];
    
    if(self) {
        self.videoDatas = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)addvideoData:(WMModel *)videoData {
    [self.videoDatas addObject:videoData];
}

- (void)removeLastVideo {
    [self.videoDatas removeLastObject];
}
 
@end
