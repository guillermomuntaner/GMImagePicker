//
//  ViewController.h
//  GMPhotoPicker
//
//  Created by Guillermo Muntaner Perelló on 17/09/14.
//  Copyright (c) 2014 Guillermo Muntaner Perelló. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
- (IBAction)launchGMImagePicker:(id)sender;
- (IBAction)launchUIImagePicker:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *gmImagePickerButton;
@property (weak, nonatomic) IBOutlet UIButton *uiImagePickerButton;
@end

