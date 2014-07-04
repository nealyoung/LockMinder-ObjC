//
//  AppDelegate.m
//  LockMinder
//
//  Created by Nealon Young on 6/28/14.
//  Copyright (c) 2014 Nealon Young. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

- (void)customizeAppearance;

@end

@implementation AppDelegate
            

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self customizeAppearance];
    return YES;
}

- (void)customizeAppearance {
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    UIColor *applicationColor = [UIColor colorWithRed:0.380 green:0.201 blue:0.891 alpha:1.000];
    self.window.tintColor = applicationColor;

    NSDictionary *barButtonItemTitleTextAttributes = @{ NSFontAttributeName: [UIFont semiboldApplicationFontOfSize:16.0f] };
    [[UIBarButtonItem appearance] setTitleTextAttributes:barButtonItemTitleTextAttributes forState:UIControlStateNormal];
    
    NSDictionary *navigationBarTitleTextAttributes = @{ NSForegroundColorAttributeName: [UIColor whiteColor],
                                                        NSFontAttributeName: [UIFont semiboldApplicationFontOfSize:19.0f] };
    [[UINavigationBar appearance] setTitleTextAttributes:navigationBarTitleTextAttributes];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setBarTintColor:applicationColor];
    
    [SVProgressHUD setFont:[UIFont semiboldApplicationFontOfSize:16.0f]];
}

@end
