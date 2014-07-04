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

static CGFloat const kClockHeight = 160.0f;
static CGFloat const kSliderHeight = 90.0f;
static CGFloat const kListHeaderHeight = 24.0f;
static CGFloat const kListInset = 20.0f;
static CGFloat const kListItemXInset = 15.0f;
static CGFloat const kListItemHeight = 25.0f;

+ (UIImage *)wallpaperImageWithBackground:(UIImage *)backgroundImage reminders:(NSArray *)reminders {
    CGRect screenBounds = [UIScreen mainScreen].bounds;
    CGFloat scale = [UIScreen mainScreen].scale;
    UIGraphicsBeginImageContextWithOptions(screenBounds.size, YES, scale);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    [backgroundImage drawInRect:[UIScreen mainScreen].bounds];
    
    CGFloat listBackgroundHeight = kListItemXInset * 2.0f + kListItemHeight * [reminders count];
    
    // Make sure the list background doesn't extend over the unlock slider
    CGFloat maxListHeight = screenBounds.size.height - kClockHeight - kSliderHeight;
    if (listBackgroundHeight > maxListHeight) {
        listBackgroundHeight = maxListHeight;
    }
    
    // If the list is smaller than the space between the clock and unlock slider, center it vertically
    CGFloat listVerticalOffset = (maxListHeight - listBackgroundHeight) / 2.0f;
    
    // Determine the size of the overlay
    CGRect listBackgroundRect = CGRectMake(kListInset,
                                           kClockHeight + listVerticalOffset,
                                           screenBounds.size.width - kListInset * 2.0f,
                                           listBackgroundHeight);
    UIBezierPath *listBackgroundPath = [UIBezierPath bezierPathWithRoundedRect:listBackgroundRect
                                                             byRoundingCorners:UIRectCornerAllCorners
                                                                   cornerRadii:CGSizeMake(10.0f, 10.0f)];
    CGContextAddPath(ctx, listBackgroundPath.CGPath);
    CGContextSetFillColorWithColor(ctx, [[UIColor colorWithWhite:1.0f alpha:0.8f] CGColor]);
    CGContextFillPath(ctx);
    
    CGRect listHeaderRect = CGRectMake(CGRectGetMinX(listBackgroundRect) + 15.0f,
                                       CGRectGetMinY(listBackgroundRect) + 2.0f,
                                       CGRectGetWidth(listBackgroundRect) - 30.0f,
                                       kListHeaderHeight);
    
    // Center the header text
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [style setAlignment:NSTextAlignmentCenter];
    [@"Reminders" drawInRect:listHeaderRect withAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Medium" size:17.0f],
                                                          NSParagraphStyleAttributeName: style}];
    
    [reminders enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        EKReminder *reminder = (EKReminder *)obj;
        CGRect listItemRect = CGRectMake(CGRectGetMinX(listBackgroundRect) + kListItemXInset,
                                         CGRectGetMinY(listBackgroundRect) + kListHeaderHeight + (kListItemHeight * idx),
                                         CGRectGetWidth(listBackgroundRect) - 30.0f,
                                         20.0f);
        [[NSString stringWithFormat:@"· %@", reminder.title] drawInRect:listItemRect
                                                         withAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Light" size:17.0f]}];
    }];
    
    // Create the UIImage to save to the user's photo library
    CGImageRef img = CGBitmapContextCreateImage(ctx);
    UIImage *wallpaperImage = [UIImage imageWithCGImage:img];
    CGImageRelease(img);
    
    UIGraphicsEndImageContext();
    
    return wallpaperImage;
}

@end
