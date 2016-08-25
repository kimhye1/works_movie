//
//  WMFilter.h
//  WorksMovie
//
//  Created by Naver on 2016. 8. 20..
//  Copyright © 2016년 worksmobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WMFilter : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *imageName;
@property (nonatomic, strong) CIFilter *ciFilter;

- (instancetype)initWithTitle:(NSString *)title imageName:(NSString *)imageName;

@end
