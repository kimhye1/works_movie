//
//  WMShowVideosController.m
//  WorksMovie
//
//  Created by Naver on 2016. 6. 29..
//  Copyright © 2016년 worksmobile. All rights reserved.
//

#import "WMShowVideosViewController.h"

@interface WMShowVideosViewController ()

@property (nonatomic, strong) NSMutableArray *dummyImages;

@end

@implementation WMShowVideosViewController

- (instancetype)init {
    self = [super init];
    
    if(self) {
        [self initializeAssets];
    }
    return self;
}

- (void)initializeAssets {
    self.dummyImages = [[NSMutableArray alloc] init];
    
    for (NSInteger i = 0 ; i < 20 ; i ++) {
        [self.dummyImages addObject:[UIImage imageNamed:@"tropical"]];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


@end
