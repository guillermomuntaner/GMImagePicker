//
//  ViewController.m
//  GMPhotoPicker
//
//  Created by Guillermo Muntaner Perelló on 17/09/14.
//  Copyright (c) 2014 Guillermo Muntaner Perelló. All rights reserved.
//

#import "ViewController.h"
#import "GMImagePickerController.h"

@import UIKit;
@import Photos;


@interface ViewController () <GMImagePickerControllerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)launchGMImagePicker:(id)sender
{
    GMImagePickerController *picker = [[GMImagePickerController alloc] init];
    picker.delegate = self;
    picker.title = @"Custom title";
    
    picker.customDoneButtonTitle = @"Finished";
    picker.customCancelButtonTitle = @"Nope";
    picker.customNavigationBarPrompt = @"Take a new photo or select an existing one!";
    
    picker.colsInPortrait = 3;
    picker.colsInLandscape = 5;
    picker.minimumInteritemSpacing = 2.0;
    
//    picker.allowsMultipleSelection = NO;
//    picker.confirmSingleSelection = YES;
//    picker.confirmSingleSelectionPrompt = @"Do you want to select the image you have chosen?";
    
//    picker.showCameraButton = YES;
//    picker.autoSelectCameraImages = YES;
    
    picker.modalPresentationStyle = UIModalPresentationPopover;

//    picker.mediaTypes = @[@(PHAssetMediaTypeImage)];

//    picker.pickerBackgroundColor = [UIColor blackColor];
//    picker.pickerTextColor = [UIColor whiteColor];
//    picker.toolbarBackgroundColor = [UIColor darkGrayColor];
//    picker.toolbarBarTintColor = [UIColor blackColor];
//    picker.toolbarTextColor = [UIColor whiteColor];
//    picker.toolbarTintColor = [UIColor redColor];
//    picker.navigationBarBackgroundColor = [UIColor darkGrayColor];
//    picker.navigationBarBarTintColor = [UIColor blackColor];
//    picker.navigationBarTextColor = [UIColor whiteColor];
//    picker.navigationBarTintColor = [UIColor redColor];
//    picker.pickerFontName = @"Verdana";
//    picker.pickerBoldFontName = @"Verdana-Bold";
//    picker.pickerFontNormalSize = 14.f;
//    picker.pickerFontHeaderSize = 17.0f;
//    picker.pickerStatusBarStyle = UIStatusBarStyleLightContent;
//    picker.useCustomFontForNavigationBar = YES;
    
    UIPopoverPresentationController *popPC = picker.popoverPresentationController;
    popPC.permittedArrowDirections = UIPopoverArrowDirectionAny;
    popPC.sourceView = _gmImagePickerButton;
    popPC.sourceRect = _gmImagePickerButton.bounds;
//    popPC.backgroundColor = [UIColor blackColor];
    
    [self showViewController:picker sender:nil];
}

- (IBAction)launchUIImagePicker:(id)sender
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    picker.modalPresentationStyle = UIModalPresentationPopover;
    
    UIPopoverPresentationController *popPC = picker.popoverPresentationController;
    popPC.permittedArrowDirections = UIPopoverArrowDirectionAny;
    popPC.sourceView = _uiImagePickerButton;
    popPC.sourceRect = _uiImagePickerButton.bounds;
    
    [self showViewController:picker sender:sender];
}


#pragma mark - UIImagePickerControllerDelegate


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    [picker.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"UIImagePickerController: User ended picking assets");
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"UIImagePickerController: User pressed cancel button");
}

#pragma mark - GMImagePickerControllerDelegate

- (void)assetsPickerController:(GMImagePickerController *)picker didFinishPickingAssets:(NSArray *)assetArray
{
    [picker.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    
    NSLog(@"GMImagePicker: User ended picking assets. Number of selected items is: %lu", (unsigned long)assetArray.count);
}

//Optional implementation:
-(void)assetsPickerControllerDidCancel:(GMImagePickerController *)picker
{
    NSLog(@"GMImagePicker: User pressed cancel button");
}
@end
