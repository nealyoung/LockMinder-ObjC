//
//  LMImageGenerator.m
//  LockMinder
//
//  Created by Nealon Young on 6/29/14.
//  Copyright (c) 2014 Nealon Young. All rights reserved.
//

#import <EventKit/EventKit.h>
#import "LMImageGenerator.h"

static CGFloat const kClockHeight = 160.0f;
static CGFloat const kSliderHeight = 90.0f;
static CGFloat const kListBackgroundInset = 20.0f;
static CGFloat const kListItemXInset = 15.0f;
static CGFloat const kListItemPadding = 2.0f;
static CGFloat const kItemBulletWidth = 5.0f;

@implementation LMImageGenerator

+ (UIImage *)wallpaperImageWithBackground:(UIImage *)backgroundImage reminders:(NSArray *)reminders {
    CGRect screenBounds = [UIScreen mainScreen].bounds;
    CGFloat scale = [UIScreen mainScreen].scale;
    UIGraphicsBeginImageContextWithOptions(screenBounds.size, YES, scale);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGFloat horizontalImageScale = screenBounds.size.width / backgroundImage.size.width,
            verticalImageScale   = screenBounds.size.height / backgroundImage.size.height;
    
    CGRect imageRect;

    if (horizontalImageScale > verticalImageScale) {
        imageRect = CGRectMake(0.0f, 0.0f, backgroundImage.size.width * horizontalImageScale, backgroundImage.size.height * horizontalImageScale);
    } else {
        imageRect = CGRectMake(0.0f, 0.0f, backgroundImage.size.width * verticalImageScale, backgroundImage.size.height * verticalImageScale);
    }
    
//    [backgroundImage drawInRect:imageRect];
    
    [self drawGradientBackgroundInContext:ctx
                           withStartColor:[UIColor colorWithRed:0.33f green:0.26f blue:0.43f alpha:1.0f]
                                 endColor:[UIColor colorWithRed:0.24f green:0.16f blue:0.36f alpha:1.0f]];
    
    CGFloat listBackgroundHeight = kListItemXInset * 2.0f;

    for (EKReminder *reminder in reminders) {
        CGRect reminderRect = [reminder.title boundingRectWithSize:CGSizeMake(screenBounds.size.width - (kListBackgroundInset * 2.0f) - (kListItemXInset * 2.0f), 9999.0f)
                                                           options:NSStringDrawingUsesLineFragmentOrigin
                                                        attributes:@{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Light" size:17.0f]}
                                                           context:nil];
        reminderRect.size.height += kListItemPadding * 2.0f;
        listBackgroundHeight += CGRectGetHeight(reminderRect);
    }
    
    
    // Make sure the list background doesn't extend over the unlock slider
    CGFloat maxListHeight = screenBounds.size.height - kClockHeight - kSliderHeight;
    if (listBackgroundHeight > maxListHeight) {
        listBackgroundHeight = maxListHeight;
    }
    
    // If the list is smaller than the space between the clock and unlock slider, center it vertically
    CGFloat listVerticalOffset = (maxListHeight - listBackgroundHeight) / 2.0f;
    
    // Determine the size of the overlay
    CGRect listBackgroundRect = CGRectMake(kListBackgroundInset,
                                           kClockHeight + listVerticalOffset,
                                           screenBounds.size.width - kListBackgroundInset * 2.0f,
                                           listBackgroundHeight);
    UIBezierPath *listBackgroundPath = [UIBezierPath bezierPathWithRoundedRect:listBackgroundRect
                                                             byRoundingCorners:UIRectCornerAllCorners
                                                                   cornerRadii:CGSizeMake(10.0f, 10.0f)];
    CGContextAddPath(ctx, listBackgroundPath.CGPath);
    CGContextSetFillColorWithColor(ctx, [[UIColor colorWithWhite:1.0f alpha:0.8f] CGColor]);
    CGContextFillPath(ctx);
    
    __block CGFloat yOffset = 0.0f;
    
    [reminders enumerateObjectsUsingBlock:^(EKReminder *reminder, NSUInteger idx, BOOL *stop) {
        // Draw the bullet point
        CGRect itemBulletRect = CGRectMake(CGRectGetMinX(listBackgroundRect) + kListItemXInset,
                                           CGRectGetMinY(listBackgroundRect) + kListItemXInset + yOffset + kItemBulletWidth * 1.5,
                                           kItemBulletWidth,
                                           kItemBulletWidth);
        UIBezierPath *itemBulletPath = [UIBezierPath bezierPathWithOvalInRect:itemBulletRect];
        CGContextBeginPath(ctx);
        CGContextAddPath(ctx, itemBulletPath.CGPath);
        CGContextSetFillColorWithColor(ctx, [UIColor blackColor].CGColor);
        CGContextFillPath(ctx);
        
        // Compute the size required to display the reminder (to support multi-line text)
        CGRect reminderRect = [reminder.title boundingRectWithSize:CGSizeMake(screenBounds.size.width - (kListBackgroundInset * 2.0f) - (kListItemXInset * 2.0f), 9999.0f)
                                                           options:NSStringDrawingUsesLineFragmentOrigin
                                                        attributes:@{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Light" size:17.0f]}
                                                           context:nil];
        reminderRect.origin = CGPointMake(CGRectGetMinX(listBackgroundRect) + kListItemXInset + (kItemBulletWidth * 2.0f),
                                          CGRectGetMinY(listBackgroundRect) + kListItemXInset + yOffset);
        reminderRect.size.height += kListItemPadding * 2.0f;

        
        yOffset += CGRectGetHeight(reminderRect);
        
        [reminder.title drawInRect:reminderRect
                    withAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Light" size:17.0f]}];
    }];
    
    CGImageRef img = CGBitmapContextCreateImage(ctx);
    UIGraphicsEndImageContext();

    UIImage *wallpaperImage = [UIImage imageWithCGImage:img];
    CGImageRelease(img);
    
    return wallpaperImage;
}

+ (void)drawGradientBackgroundInContext:(CGContextRef)context withStartColor:(UIColor *)startColor endColor:(UIColor *)endColor {
    CGGradientRef gradient;
    CGColorSpaceRef colorspace;
    CGFloat locations[2] = { 0.0, 1.0 };
    
    NSArray *colors = @[(id)startColor.CGColor,
                        (id)endColor.CGColor];
    
    colorspace = CGColorSpaceCreateDeviceRGB();
    
    gradient = CGGradientCreateWithColors(colorspace, (CFArrayRef)colors, locations);
    
    CGRect screenBounds = [UIScreen mainScreen].bounds;

    CGPoint startPoint = CGPointMake(0.0f, 0.0f), endPoint = CGPointMake(0.0f, CGRectGetMaxY(screenBounds));
    
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
}

@end
