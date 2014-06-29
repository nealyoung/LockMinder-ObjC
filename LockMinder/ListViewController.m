//
//  ViewController.m
//  LockMinder
//
//  Created by Nealon Young on 6/28/14.
//  Copyright (c) 2014 Nealon Young. All rights reserved.
//

#import <EventKit/EventKit.h>
#import "ListViewController.h"
#import "ImageGenerator.h"
#import "ImagePreviewViewController.h"
#import "ReminderCell.h"

@interface ListViewController ()

@property EKEventStore *eventStore;
@property NSMutableArray *reminders;
@property IBOutlet UITableView *tableView;

- (void)generateButtonPressed;
- (void)importReminders;

@end

@implementation ListViewController
            
- (void)viewDidLoad {
    [super viewDidLoad];
    self.eventStore = [[EKEventStore alloc] init];
    [self importReminders];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Generate"
                                                                             style:UIBarButtonItemStyleBordered
                                                                            target:self
                                                                            action:@selector(generateButtonPressed)];
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    self.tableView.editing = editing;
}

- (void)generateButtonPressed {
    if (![self.reminders count]) {
        return;
    }
    
    UIImage *wallpaperImage = [ImageGenerator wallpaperImageWithBackground:[UIImage imageNamed:@"Wallpaper"] reminders:self.reminders];
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ImagePreviewViewController *previewViewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"ImagePreviewViewController"];
    
    // Access the view controller's view property to instantiate the image view
    [previewViewController view];
    previewViewController.imageView.image = wallpaperImage;
    
    [self.navigationController presentViewController:previewViewController animated:YES completion:nil];
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
