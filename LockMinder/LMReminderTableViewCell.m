//
//  ReminderCell.m
//  LockMinder
//
//  Created by Nealon Young on 6/29/14.
//  Copyright (c) 2014 Nealon Young. All rights reserved.
//

#import "LMReminderTableViewCell.h"

@implementation LMReminderTableViewCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionIndicatorView.selected = selected;
}

@end
