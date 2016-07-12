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
        self.videosURLArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)addvideoURL:(NSURL *) url {
    [self.videosURLArray addObject:url];
}

- (void)removeLastVideoURL {
    [self.videosURLArray removeLastObject];
}
 
@end
