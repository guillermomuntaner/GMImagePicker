//
//  ViewController.h
//  GMPhotoPicker
//
//  Created by Guillermo Muntaner Perelló on 17/09/14.
//  Copyright (c) 2014 Guillermo Muntaner Perelló. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (strong) UIImagePickerController* imagePickerController;
- (IBAction)testButton:(id)sender;
- (IBAction)defaultButton:(id)sender;

@end

