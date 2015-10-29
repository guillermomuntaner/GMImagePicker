//
//  GMGridViewCell.h
//  GMPhotoPicker
//
//  Created by Guillermo Muntaner Perelló on 19/09/14.
//  Copyright (c) 2014 Guillermo Muntaner Perelló. All rights reserved.
//

@import UIKit;
@import Photos;


@interface GMGridViewCell : UICollectionViewCell

@property (nonatomic, strong) PHAsset *asset;
//The imageView
@property (nonatomic, strong) UIImageView *imageView;
//Video additional information
@property (nonatomic, strong) UIImageView *videoIcon;
@property (nonatomic, strong) UILabel *videoDuration;
@property (nonatomic, strong) UIView *gradientView;
@property (nonatomic, strong) CAGradientLayer *gradient;
//Selection overlay
@property (nonatomic) BOOL shouldShowSelection;
@property (nonatomic, strong) UIView *coverView;
@property (nonatomic, strong) UIButton *selectedButton;

@property (nonatomic, assign, getter = isEnabled) BOOL enabled;

- (void)bind:(PHAsset *)asset;

@end