//
//  ImagePreviewViewController.m
//  LockMinder
//
//  Created by Nealon Young on 6/29/14.
//  Copyright (c) 2014 Nealon Young. All rights reserved.
//

#import "ImagePreviewViewController.h"
#import "SVProgressHUD.h"

@interface ImagePreviewViewController ()

@property IBOutlet UILabel *clockLabel;
@property IBOutlet UILabel *dateLabel;

@property IBOutlet UIButton *cancelButton;
@property IBOutlet UIButton *saveButton;

- (IBAction)cancelButtonPressed:(id)sender;
- (IBAction)saveButtonPressed:(id)sender;

@end

@implementation ImagePreviewViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do some hacky stuff to get rounded periods/colons in the clock
    NSArray *clockFontAttributes = @[@{ UIFontFeatureTypeIdentifierKey: @(6),
                                        UIFontFeatureSelectorIdentifierKey: @(1) },
                                     @{ UIFontFeatureTypeIdentifierKey: @(17),
                                        UIFontFeatureSelectorIdentifierKey: @(1) }];
    UIFont *clockFont = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:90.0f];
    UIFontDescriptor *clockFontDescriptor = [[clockFont fontDescriptor] fontDescriptorByAddingAttributes: @{ UIFontDescriptorFeatureSettingsAttribute: clockFontAttributes }];
    self.clockLabel.font = [UIFont fontWithDescriptor:clockFontDescriptor size:0.0f];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (IBAction)cancelButtonPressed:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)saveButtonPressed:(id)sender {
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    UIImageWriteToSavedPhotosAlbum(self.imageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo; {
    [SVProgressHUD showSuccessWithStatus:@"Wallpaper Saved"];
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

@end