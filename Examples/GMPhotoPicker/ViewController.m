//
//  ViewController.m
//  GMPhotoPicker
//
//  Created by Guillermo Muntaner Perelló on 17/09/14.
//  Copyright (c) 2014 Guillermo Muntaner Perelló. All rights reserved.
//

#import "ViewController.h"
#import "GMImagePickerController.h"

@interface ViewController () <GMImagePickerControllerDelegate>

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

- (IBAction)defaultButton:(id)sender {
}

#pragma mark - GMImagePickerControllerDelegate

//Use this to set up a default folder for the picker. By default it opens albums folder.
/*- (BOOL)assetsPickerController:(CTAssetsPickerController *)picker isDefaultAssetsGroup:(ALAssetsGroup *)group
 {
 return ([[group valueForProperty:ALAssetsGroupPropertyType] integerValue] == ALAssetsGroupSavedPhotos);
 }*/

- (void)assetsPickerController:(GMImagePickerController *)picker didFinishPickingAssets:(NSArray *)assetArray
{
    [picker.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    
    NSLog(@" Number of selected items is: %lu", (unsigned long)assetArray.count);
}

-(void)assetsPickerControllerDidCancel:(GMImagePickerController *)picker
{
    NSLog(@"User pressed cancel button");
}
@end
