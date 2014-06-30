//
//  CheckmarkButton.m
//  LockMinder
//
//  Created by Nealon Young on 6/29/14.
//  Copyright (c) 2014 Nealon Young. All rights reserved.
//

#import "CheckmarkButton.h"

@interface CheckmarkButton ()

@property UIImageView *imageView;

@end

static CGFloat const kCheckboxInset = 2.0f;

@implementation CheckmarkButton

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    self.opaque = NO;
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    UIBezierPath *borderPath = [UIBezierPath bezierPathWithOvalInRect:CGRectInset(rect, kCheckboxInset, kCheckboxInset)];
    CGContextAddPath(ctx, borderPath.CGPath);
    CGContextSetStrokeColorWithColor(ctx, self.tintColor.CGColor);
    CGContextStrokePath(ctx);
    
    if (self.selected) {
        
        CGContextBeginPath(ctx);
        UIBezierPath *circlePath = [UIBezierPath bezierPathWithOvalInRect:CGRectInset(rect, kCheckboxInset * 2.0f, kCheckboxInset * 2.0f)];
        CGContextAddPath(ctx, circlePath.CGPath);
        CGContextSetFillColorWithColor(ctx, self.tintColor.CGColor);
        CGContextFillPath(ctx);

        // Draw the checkmark
//        CGContextBeginPath(ctx);
//        CGContextMoveToPoint(ctx, CGRectGetWidth(rect) * 0.2f, CGRectGetMidY(rect));
//        CGContextAddLineToPoint(ctx, CGRectGetWidth(rect) * 0.37f, CGRectGetMidY(rect) * 1.32f);
//        CGContextAddLineToPoint(ctx, CGRectGetWidth(rect) * 0.72f, CGRectGetHeight(rect) * 0.29f);
//        CGContextSetLineWidth(ctx, 2.0f);
//        CGContextSetStrokeColorWithColor(ctx, [UIColor whiteColor].CGColor);
//        CGContextStrokePath(ctx);
    } else {
        
    }
}

- (void)setSelected:(BOOL)selected {
    _selected = selected;
    [self setNeedsDisplay];
}

@end
