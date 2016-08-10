//
//  WMShareVideo.h
//  WorksMovie
//
//  Created by Naver on 2016. 7. 22..
//  Copyright © 2016년 worksmobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface WMMediaSharer : UIViewController

- (UIActivityViewController *)shareVideo:(NSURL *)outputURL;

@end
