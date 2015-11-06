//
//  GMAlbumsViewController.h
//  GMPhotoPicker
//
//  Created by Guillermo Muntaner Perelló on 19/09/14.
//  Copyright (c) 2014 Guillermo Muntaner Perelló. All rights reserved.
//

#import <UIKit/UIKit.h>

// Measuring IOS8 Photos APP at @2x (iPhone5s):
//   The rows are 180px/90pts
//   Left image border is 21px/10.5pts
//   Separation between image and text is 42px/21pts (double the previouse one)
//   The bigger image measures 139px/69.5pts including 1px/0.5pts white border.
//   The second image measures 131px/65.6pts including 1px/0.5pts white border. Only 3px/1.5pts visible
//   The third image measures 123px/61.5pts  including 1px/0.5pts white border. Only 3px/1.5pts visible

static int kAlbumRowHeight = 90;
static int kAlbumLeftToImageSpace = 10;
static int kAlbumImageToTextSpace = 21;
static float const kAlbumGradientHeight = 20.0f;
static CGSize const kAlbumThumbnailSize1 = {70.0f , 70.0f};
static CGSize const kAlbumThumbnailSize2 = {66.0f , 66.0f};
static CGSize const kAlbumThumbnailSize3 = {62.0f , 62.0f};


@interface GMAlbumsViewController : UITableViewController

- (void)selectAllAlbumsCell;

@end