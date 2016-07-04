//
//  AppDelegate.m
//  WorksMovie
//
//  Created by Naver on 2016. 6. 29..
//  Copyright © 2016년 worksmobile. All rights reserved.
//

#import "AppDelegate.h"
#import "WMViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self setupWindow];
    [self setupRootViewController];
    
    return YES;
}

- (void)setupWindow {
    UIWindow *window = [[UIWindow alloc] init];
    self.window = window;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];

}

- (void)setupRootViewController {
    WMViewController *viewController = [[WMViewController alloc] init];
    [self.window setRootViewController:viewController];

}

@end
