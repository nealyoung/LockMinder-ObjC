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

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    self.selected = !self.selected;
}

- (void)drawRect:(CGRect)rect {
    UIBezierPath *borderPath = [UIBezierPath bezierPathWithOvalInRect:CGRectInset(rect, kCheckboxInset, kCheckboxInset)];
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextAddPath(ctx, borderPath.CGPath);
    
    if (self.selected) {
        CGContextSetFillColorWithColor(ctx, [UIColor redColor].CGColor);
        CGContextFillPath(ctx);
        
        CGContextBeginPath(ctx);
        CGContextMoveToPoint(ctx, CGRectGetWidth(rect) * 0.2f, CGRectGetMidY(rect));
        CGContextAddLineToPoint(ctx, CGRectGetWidth(rect) * 0.37f, CGRectGetMidY(rect) * 1.32f);
        CGContextAddLineToPoint(ctx, CGRectGetWidth(rect) * 0.72f, CGRectGetHeight(rect) * 0.29f);
        CGContextSetLineWidth(ctx, 2.0f);
        CGContextSetStrokeColorWithColor(ctx, [UIColor whiteColor].CGColor);
        CGContextStrokePath(ctx);
    } else {
        CGContextSetStrokeColorWithColor(ctx, [UIColor lightGrayColor].CGColor);
        CGContextStrokePath(ctx);
    }
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    [self setNeedsDisplay];
}

@end
