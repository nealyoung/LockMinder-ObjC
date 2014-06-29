//
//  ImageGenerator.m
//  LockMinder
//
//  Created by Nealon Young on 6/29/14.
//  Copyright (c) 2014 Nealon Young. All rights reserved.
//

#import <EventKit/EventKit.h>
#import "ImageGenerator.h"

@implementation ImageGenerator

static CGFloat const kReminderBackgroundMargin = 20.0f;
static CGFloat const kClockHeight = 160.0f;
static CGFloat const kSliderHeight = 90.0f;

static CGFloat const kListItemMargin = 15.0f;
static CGFloat const kListItemHeight = 25.0f;

+ (UIImage *)wallpaperImageWithBackground:(UIImage *)backgroundImage reminders:(NSArray *)reminders {
    CGRect screenBounds = [UIScreen mainScreen].bounds;
    CGFloat scale = [UIScreen mainScreen].scale;
    UIGraphicsBeginImageContextWithOptions(screenBounds.size, YES, scale);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    [backgroundImage drawInRect:[UIScreen mainScreen].bounds];
    
    CGFloat backgroundOverlayHeight = kListItemMargin * 2.0f + kListItemHeight * [reminders count];
    CGFloat maxOverlayHeight = screenBounds.size.height - kClockHeight - kSliderHeight;
    
    if (backgroundOverlayHeight > maxOverlayHeight) {
        backgroundOverlayHeight = maxOverlayHeight;
    }
    
    // Determine the size of the overlay
    CGRect reminderBackgroundRect = CGRectMake(kReminderBackgroundMargin,
                                               kClockHeight,
                                               screenBounds.size.width - kReminderBackgroundMargin * 2.0f,
                                               backgroundOverlayHeight);
    UIBezierPath *reminderBackgroundPath = [UIBezierPath bezierPathWithRoundedRect:reminderBackgroundRect
                                                                 byRoundingCorners:UIRectCornerAllCorners
                                                                       cornerRadii:CGSizeMake(10.0f, 10.0f)];
    CGContextAddPath(ctx, reminderBackgroundPath.CGPath);
    CGContextSetFillColorWithColor(ctx, [[UIColor colorWithWhite:1.0f alpha:0.8f] CGColor]);
    CGContextFillPath(ctx);
    
    [reminders enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        EKReminder *reminder = (EKReminder *)obj;
        CGRect listItemRect = CGRectMake(CGRectGetMinX(reminderBackgroundRect) + kListItemMargin,
                                         CGRectGetMinY(reminderBackgroundRect) + kListItemMargin + (kListItemHeight * idx),
                                         CGRectGetWidth(reminderBackgroundRect) - 30.0f,
                                         20.0f);
        [reminder.title drawInRect:listItemRect
                    withAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Light" size:16.0f]}];
    }];
    
    // Create the UIImage to save to the user's photo library
    CGImageRef img = CGBitmapContextCreateImage(ctx);
    UIImage *wallpaperImage = [UIImage imageWithCGImage:img];
    CGImageRelease(img);
    
    UIGraphicsEndImageContext();
    
    return wallpaperImage;
}

@end
