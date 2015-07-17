//
//  HFAlertViewController.h
//  HackerFeed
//
//  Created by Nealon Young on 7/13/15.
//  Copyright (c) 2015 Nealon Young. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NYAlertAction.h"

@interface NYAlertViewController : UIViewController

@property (nonatomic) NSString *message;
@property (nonatomic, readonly) NSArray *actions;
@property (nonatomic) UIView *alertViewContentView;

- (void)addAction:(NYAlertAction *)action;

@end
