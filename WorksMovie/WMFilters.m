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
    [self.filters addObject:[[WMFilter alloc] initWithTitle:@"Original" imageName:@"CIColorControls"]];
    [self.filters addObject:[[WMFilter alloc] initWithTitle:@"Chrome" imageName:@"CIPhotoEffectChrome"]];
    [self.filters addObject:[[WMFilter alloc] initWithTitle:@"Fade" imageName:@"CIPhotoEffectFade"]];
    [self.filters addObject:[[WMFilter alloc] initWithTitle:@"Instant" imageName:@"CIPhotoEffectInstant"]];
    [self.filters addObject:[[WMFilter alloc] initWithTitle:@"Mono" imageName:@"CIPhotoEffectMono"]];
    [self.filters addObject:[[WMFilter alloc] initWithTitle:@"Noir" imageName:@"CIPhotoEffectNoir"]];
    [self.filters addObject:[[WMFilter alloc] initWithTitle:@"Process" imageName:@"CIPhotoEffectProcess"]];
    [self.filters addObject:[[WMFilter alloc] initWithTitle:@"Tonal" imageName:@"CIPhotoEffectTonal"]];
    [self.filters addObject:[[WMFilter alloc] initWithTitle:@"Transfer" imageName:@"CIPhotoEffectTransfer"]];
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
