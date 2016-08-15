//
//  WMFilter.m
//  WorksMovie
//
//  Created by Naver on 2016. 8. 20..
//  Copyright © 2016년 worksmobile. All rights reserved.
//

#import "WMFilter.h"

@implementation WMFilter

- (instancetype)initWithTitle:(NSString *)title imageName:(NSString *)imageName {
    self = [super init];
    
    if (self) {
        self.title = title;
        self.imageName = imageName;
        self.ciFilter = [CIFilter filterWithName: self.imageName];
    }
    
    return self;
}

@end
