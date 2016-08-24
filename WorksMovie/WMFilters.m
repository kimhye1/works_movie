//
//  WMFilters.m
//  WorksMovie
//
//  Created by Naver on 2016. 8. 20..
//  Copyright © 2016년 worksmobile. All rights reserved.
//

#import "WMFilters.h"

@implementation WMFilters

- (instancetype)init {
    
    self = [super self];
    
    if (self) {
        [self setupFilters];
    }
    
    return self;
}

- (void)setupFilters {
    self.filters = [[NSMutableArray alloc] init];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"filters"ofType:@"plist"];
    NSArray *filtersFromPList = [[NSArray alloc] initWithContentsOfFile:path];
    
    for (NSMutableArray *filter in filtersFromPList) {
        [self.filters addObject:[[WMFilter alloc] initWithTitle:filter[0] imageName:filter[1]]];
    }
}

- (NSInteger)count {
    return self.filters.count;
}

- (WMFilter *)filterWithIndex:(NSInteger)index {
    if (index > self.filters.count) {
        return nil;
    }
    
    return self.filters[index];
}

@end
