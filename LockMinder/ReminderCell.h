//
//  ReminderCell.h
//  LockMinder
//
//  Created by Nealon Young on 6/29/14.
//  Copyright (c) 2014 Nealon Young. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelectionIndicatorView.h"

@interface ReminderCell : UITableViewCell

@property IBOutlet SelectionIndicatorView *selectionIndicatorView;
@property IBOutlet UILabel *reminderLabel;

@end
