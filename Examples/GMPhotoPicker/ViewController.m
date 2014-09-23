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

//Multiple picker properties
@property (nonatomic, copy) NSArray *selectedImages;
@property (nonatomic, strong) UIPopoverController *popover;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    /*UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
    cameraUI.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    if([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0)
    {
        UIPopoverController *popVC= [[UIPopoverController alloc] initWithContentViewController:cameraUI];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [popVC presentPopoverFromRect:CGRectMake(0, 0, 400, 400) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:NO];
        });
        
    }*/
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)testButton:(id)sender
{
    
}


- (IBAction)launchGMImagePicker:(id)sender
{
    if (!self.selectedImages)
        self.selectedImages = [[NSMutableArray alloc] init];
    
    GMImagePickerController *picker = [[GMImagePickerController alloc] init];
    picker.delegate             = self;
    picker.selectedAssets       = [NSMutableArray arrayWithArray:self.selectedImages];
    picker.colsInPortrait=3;
    picker.colsInLandscape=5;
    picker.minimumInteritemSpacing=2.0;
    
    [self presentViewController:picker animated:YES completion:nil];
}

- (IBAction)launchUIImagePickerControllerSourceTypeSavedPhotosAlbum:(id)sender
{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.modalPresentationStyle = UIModalPresentationFullScreen;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    imagePickerController.delegate = self;
    self.imagePickerController = imagePickerController;
    self.imagePickerController.modalPresentationStyle = UIModalPresentationPopover;
    UIPopoverPresentationController *popPC = self.imagePickerController.popoverPresentationController;
    popPC.permittedArrowDirections = UIPopoverArrowDirectionAny;
    [self showViewController:self.imagePickerController sender:self];
}


- (IBAction)launchUIImagePickerControllerSourceTypePhotoLibrary:(id)sender
{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.modalPresentationStyle = UIModalPresentationFullScreen;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerController.delegate = self;
    self.imagePickerController = imagePickerController;
    self.imagePickerController.modalPresentationStyle = UIModalPresentationPopover;
    UIPopoverPresentationController *popPC = self.imagePickerController.popoverPresentationController;
    popPC.permittedArrowDirections = UIPopoverArrowDirectionAny;
    [self showViewController:self.imagePickerController sender:self];
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
