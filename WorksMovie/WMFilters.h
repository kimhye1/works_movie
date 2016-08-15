//
//  WMFilters.h
//  WorksMovie
//
//  Created by Naver on 2016. 8. 20..
//  Copyright © 2016년 worksmobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WMFilter.h"

@interface WMFilters : NSObject

@property (nonatomic, strong) NSMutableArray *filters;

- (NSInteger)count;
- (WMFilter *)filterWithIndex:(NSInteger)index;

@end
