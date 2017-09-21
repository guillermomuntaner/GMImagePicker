//
//  GMGridViewController.h
//  GMPhotoPicker
//
//  Created by Guillermo Muntaner Perelló on 19/09/14.
//  Copyright (c) 2014 Guillermo Muntaner Perelló. All rights reserved.
//

#if __has_feature(modules)
    @import UIKit;
    @import Photos;
#else
    #import <UIKit/UIKit.h>
    #import <Photos/Photos.h>
#endif

#import "GMImagePickerController.h"

@interface GMGridViewController : UICollectionViewController

@property (strong) PHFetchResult *assetsFetchResults;

-(id)initWithPicker:(GMImagePickerController *)picker;
    
@end