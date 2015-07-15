//
//  LMImagePreviewViewController.m
//  LockMinder
//
//  Created by Nealon Young on 6/29/14.
//  Copyright (c) 2014 Nealon Young. All rights reserved.
//

#import <AssetsLibrary/AssetsLibrary.h>
#import "LMImagePreviewViewController.h"
#import "LMImageGenerator.h"
#import "SVProgressHUD.h"

@interface LMImagePreviewViewController ()

@property IBOutlet UILabel *clockLabel;
@property IBOutlet UILabel *dateLabel;

@property IBOutlet UIButton *changeBackgroundButton;
@property IBOutlet UIButton *cancelButton;
@property IBOutlet UIButton *saveButton;

- (void)imageDidFinishSavingWithError:(NSError *)error;

- (IBAction)changeImageButtonPressed:(id)sender;
- (IBAction)cancelButtonPressed:(id)sender;
- (IBAction)saveButtonPressed:(id)sender;

@end

static NSString * const kSavedPhotosAlbumName = @"LockMinder Wallpapers";

@implementation LMImagePreviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.changeBackgroundButton.titleLabel.font = [UIFont applicationFontOfSize:16.0f];
    self.cancelButton.titleLabel.font = [UIFont applicationFontOfSize:18.0f];
    self.saveButton.titleLabel.font = [UIFont applicationFontOfSize:18.0f];
    
    // Do some hacky stuff to get rounded periods/colons in the clock
    NSArray *clockFontAttributes = @[@{ UIFontFeatureTypeIdentifierKey: @(6),
                                        UIFontFeatureSelectorIdentifierKey: @(1) },
                                     @{ UIFontFeatureTypeIdentifierKey: @(17),
                                        UIFontFeatureSelectorIdentifierKey: @(1) }];
    UIFont *clockFont = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:90.0f];
    UIFontDescriptor *clockFontDescriptor = [[clockFont fontDescriptor] fontDescriptorByAddingAttributes: @{ UIFontDescriptorFeatureSettingsAttribute: clockFontAttributes }];
    self.clockLabel.font = [UIFont fontWithDescriptor:clockFontDescriptor size:0.0f];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"h:mm"];
    self.clockLabel.text = [formatter stringFromDate:[NSDate date]];
    
    [formatter setDateFormat:@"EEEE, MMMM d"];
    self.dateLabel.text = [formatter stringFromDate:[NSDate date]];
}

- (void)imageDidFinishSavingWithError:(NSError *)error {
    if (error) {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Error saving wallpaper", nil)];
    } else {
        [SVProgressHUD showSuccessWithStatus:@"Wallpaper saved"];
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)setReminders:(NSArray *)reminders {
    _reminders = reminders;
    self.imageView.image = [LMImageGenerator wallpaperImageWithBackground:self.backgroundImage reminders:self.reminders];
}

- (void)setBackgroundImage:(UIImage *)backgroundImage {
    _backgroundImage = backgroundImage;
    self.imageView.image = [LMImageGenerator wallpaperImageWithBackground:self.backgroundImage reminders:self.reminders];
}

#pragma mark - Actions

- (IBAction)changeImageButtonPressed:(id)sender {
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

- (IBAction)cancelButtonPressed:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)saveButtonPressed:(id)sender {
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    
    ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
    
    [assetsLibrary writeImageToSavedPhotosAlbum:self.imageView.image.CGImage
                                    orientation:(ALAssetOrientation)self.imageView.image.imageOrientation
                                completionBlock:^(NSURL *assetURL, NSError *error) {
                                    [assetsLibrary assetForURL:assetURL
                                                   resultBlock:^(ALAsset *asset) {
                                                       __block BOOL albumCreated = NO;
                                                       [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAlbum
                                                                                    usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
                                                                                        if ([[group valueForProperty:ALAssetsGroupPropertyName] isEqualToString:kSavedPhotosAlbumName]) {
                                                                                            [group addAsset:asset];
                                                                                            albumCreated = YES;
                                                                                            *stop = YES;
                                                                                            [self imageDidFinishSavingWithError:error];
                                                                                        }
                                                                                        
                                                                                        // On the last iteration (when group is nil), we check if the album has been created
                                                                                        if (!group && !albumCreated) {
                                                                                            [assetsLibrary addAssetsGroupAlbumWithName:kSavedPhotosAlbumName
                                                                                                                           resultBlock:^(ALAssetsGroup *group) {
                                                                                                                               [group addAsset:asset];
                                                                                                                               [self imageDidFinishSavingWithError:nil];
                                                                                                                           } failureBlock:^(NSError *error) {
                                                                                                                               [self imageDidFinishSavingWithError:error];
                                                                                                                           }];
                                                                                        }
                                                                                    } failureBlock:^(NSError *error) {
                                                                                        [self imageDidFinishSavingWithError:error];
                                                                                    }];
                                                   } failureBlock:^(NSError *error) {
                                                       [self imageDidFinishSavingWithError:error];
                                                   }];
                                }];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    self.backgroundImage = info[UIImagePickerControllerOriginalImage];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

@end
