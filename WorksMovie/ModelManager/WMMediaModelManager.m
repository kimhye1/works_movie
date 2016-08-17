//
//  WMMediaModelManager.m
//  WorksMovie
//
//  Created by Naver on 2016. 7. 12..
//  Copyright © 2016년 worksmobile. All rights reserved.
//

#import "WMMediaModelManager.h"

@implementation WMMediaModelManager

- (instancetype)init {
    self = [super init];
    
    if (self) {
        self.mediaDatas = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)addMediaData:(WMMediaModel *)MediaData {
    [self.mediaDatas addObject:MediaData];
}

- (void)removeLastMedia {
    [self.mediaDatas removeLastObject];
}

- (void)removeObjectAtIndex:(NSUInteger)index {
    [self.mediaDatas removeObjectAtIndex:index];
}

@end
