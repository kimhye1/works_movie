//
//  WMShootingVideoViewController.h
//  WorksMovie
//
//  Created by Naver on 2016. 6. 29..
//  Copyright © 2016년 worksmobile. All rights reserved.
//

/*
 * 동영상 촬영 및 삭제 기능 구현.
 */

#import <UIKit/UIKit.h>
#import "DACircularProgressView.h"

@interface WMShootingVideoViewController : UIViewController

@property (nonatomic, strong) DACircularProgressView *shootingButton;
@property (nonatomic, strong) NSMutableArray *progressArray;
@property (nonatomic, strong) UILabel *recordingTimeCounter;
@property (nonatomic, assign) int time;
@property (nonatomic, assign) int countOutTime;
@property (nonatomic, strong) NSMutableArray *countOutTimeArray;

@end
