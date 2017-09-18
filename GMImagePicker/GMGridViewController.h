//
//  GMGridViewController.h
//  GMPhotoPicker
//
//  Created by Guillermo Muntaner Perelló on 19/09/14.
//  Copyright (c) 2014 Guillermo Muntaner Perelló. All rights reserved.
//


#import "GMImagePickerController.h"
#include <UIKit/UIKit.h>
#include <Photos/Photos.h>


@interface GMGridViewController : UICollectionViewController

@property (strong,nonatomic) PHFetchResult *assetsFetchResults;

-(id)initWithPicker:(GMImagePickerController *)picker;

@end
