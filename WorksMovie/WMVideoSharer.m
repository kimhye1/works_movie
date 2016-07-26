//
//  WMShareVideo.m
//  WorksMovie
//
//  Created by Naver on 2016. 7. 22..
//  Copyright © 2016년 worksmobile. All rights reserved.
//

#import "WMVideoSharer.h"
#import "WMVideoSaver.h"

@interface WMVideoSharer()

@end

@implementation WMVideoSharer


- (UIActivityViewController *)shareVideo:(NSURL *)outputURL {

    
    NSArray* actItems = [NSArray arrayWithObjects:outputURL, nil];
    
    UIActivityViewController *activityView = [[UIActivityViewController alloc]
                                               initWithActivityItems:actItems
                                               applicationActivities:nil];
    return activityView;
}

@end
