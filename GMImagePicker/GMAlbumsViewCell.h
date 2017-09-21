//
//  GMAlbumsViewCell.h
//  GMPhotoPicker
//
//  Created by Guillermo Muntaner Perelló on 22/09/14.
//  Copyright (c) 2014 Guillermo Muntaner Perelló. All rights reserved.
//

#if __has_feature(modules)
    @import UIKit;
    @import Photos;
#else
    #import <UIKit/UIKit.h>
    #import <Photos/Photos.h>
#endif

@interface GMAlbumsViewCell : UITableViewCell

@property (strong) PHFetchResult *assetsFetchResults;
@property (strong) PHAssetCollection *assetCollection;

//The labels
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *infoLabel;
//The imageView
@property (nonatomic, strong) UIImageView *imageView1;
@property (nonatomic, strong) UIImageView *imageView2;
@property (nonatomic, strong) UIImageView *imageView3;
//Video additional information
@property (nonatomic, strong) UIImageView *videoIcon;
@property (nonatomic, strong) UIImageView *slowMoIcon;
@property (nonatomic, strong) UIView* gradientView;
@property (nonatomic, strong) CAGradientLayer *gradient;
//Selection overlay

- (void)setVideoLayout:(BOOL)isVideo;
@end
