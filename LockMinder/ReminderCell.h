//
//  ReminderCell.h
//  LockMinder
//
//  Created by Nealon Young on 6/29/14.
//  Copyright (c) 2014 Nealon Young. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CheckmarkButton.h"

@interface ReminderCell : UITableViewCell

@property IBOutlet CheckmarkButton *checkmarkButton;
@property IBOutlet UILabel *reminderLabel;

@end
