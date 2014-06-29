//
//  ImageGenerator.h
//  LockMinder
//
//  Created by Nealon Young on 6/29/14.
//  Copyright (c) 2014 Nealon Young. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageGenerator : NSObject

+ (UIImage *)wallpaperImageWithBackground:(UIImage *)backgroundImage reminders:(NSArray *)reminders;

@end
