//
//  ViewController.m
//  LockMinder
//
//  Created by Nealon Young on 6/28/14.
//  Copyright (c) 2014 Nealon Young. All rights reserved.
//

#import <EventKit/EventKit.h>
#import "ListViewController.h"
#import "ReminderCell.h"

@interface ListViewController ()

@property EKEventStore *eventStore;
@property NSMutableArray *reminders;
@property IBOutlet UITableView *tableView;

- (UIImage *)createBackgroundImage;
- (void)importReminders;

@end

static CGFloat const kReminderBackgroundMargin = 20.0f;
static CGFloat const kClockHeight = 160.0f;
static CGFloat const kSliderHeight = 90.0f;

static CGFloat const kListItemMargin = 15.0f;
static CGFloat const kListItemHeight = 24.0f;

@implementation ListViewController
            
- (void)viewDidLoad {
    [super viewDidLoad];
    self.eventStore = [[EKEventStore alloc] init];
    [self importReminders];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Generate"
                                                                             style:UIBarButtonItemStyleBordered
                                                                            target:self
                                                                            action:@selector(createBackgroundImage)];
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIImage *)createBackgroundImage {
    CGRect screenBounds = [UIScreen mainScreen].bounds;
    UIGraphicsBeginImageContext(screenBounds.size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    UIImage *wallpaperImage = [UIImage imageNamed:@"WallpaperTest"];
    [wallpaperImage drawInRect:[UIScreen mainScreen].bounds];
    
    // Determine the size of the overlay
    CGRect reminderBackgroundRect = CGRectMake(kReminderBackgroundMargin,
                                               kClockHeight,
                                               screenBounds.size.width - kReminderBackgroundMargin * 2.0f,
                                               screenBounds.size.height - kClockHeight - kSliderHeight);
    UIBezierPath *reminderBackgroundPath = [UIBezierPath bezierPathWithRoundedRect:reminderBackgroundRect
                                                                 byRoundingCorners:UIRectCornerAllCorners
                                                                       cornerRadii:CGSizeMake(10.0f, 10.0f)];
    CGContextAddPath(ctx, reminderBackgroundPath.CGPath);
    CGContextSetFillColorWithColor(ctx, [[UIColor colorWithWhite:1.0f alpha:0.8f] CGColor]);
    CGContextFillPath(ctx);
    
    [self.reminders enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
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
    UIImage *backgroundImage = [UIImage imageWithCGImage:img];
    CGImageRelease(img);
    
    UIGraphicsEndImageContext();
    
    return backgroundImage;
}

- (void)importReminders {
    [self.eventStore requestAccessToEntityType:EKEntityTypeReminder completion:^(BOOL granted, NSError *error) {
        if (!granted) {
            NSLog(@"Permission refused");
            return;
        }
        
        EKCalendar *defaultReminderCalendar = self.eventStore.defaultCalendarForNewReminders;
        NSPredicate *completedRemindersPredicate = [self.eventStore predicateForIncompleteRemindersWithDueDateStarting:nil
                                                                                                                ending:nil
                                                                                                             calendars:@[defaultReminderCalendar]];
        
        [self.eventStore fetchRemindersMatchingPredicate:completedRemindersPredicate completion:^(NSArray *reminders) {
            for (EKReminder *reminder in reminders) {
                if (reminder.completed) {
                    NSLog(@"%@", reminder.title);
                }
            }
            
            self.reminders = [reminders mutableCopy];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }];
    }];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    self.tableView.editing = editing;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.reminders count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ReminderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReminderCell" forIndexPath:indexPath];
    EKReminder *reminder = self.reminders[indexPath.row];
    cell.reminderLabel.text = reminder.title;
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    
}

@end
