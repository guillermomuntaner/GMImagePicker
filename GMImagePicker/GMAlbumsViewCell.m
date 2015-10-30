//
//  GMAlbumsViewCell.m
//  GMPhotoPicker
//
//  Created by Guillermo Muntaner Perelló on 22/09/14.
//  Copyright (c) 2014 Guillermo Muntaner Perelló. All rights reserved.
//

#import "GMAlbumsViewCell.h"
#import "GMAlbumsViewController.h"
#import "GMImagePickerController.h"
#import <QuartzCore/QuartzCore.h>

@implementation GMAlbumsViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.contentView.translatesAutoresizingMaskIntoConstraints = YES;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.opaque                             = NO;
        self.backgroundColor                    = [UIColor clearColor];
        self.textLabel.backgroundColor          = self.backgroundColor;
        self.detailTextLabel.backgroundColor    = self.backgroundColor;
        // self.isAccessibilityElement             = YES;

        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        // Border width of 1 pixel:
        float borderWidth = 1.0/[UIScreen mainScreen].scale;
        
        // ImageView
        _imageView3 = [UIImageView new];
        _imageView3.contentMode = UIViewContentModeScaleAspectFill;
        _imageView3.frame = CGRectMake(kAlbumLeftToImageSpace+4, 8, kAlbumThumbnailSize3.width, kAlbumThumbnailSize3.height );
        [_imageView3.layer setBorderColor: [[UIColor whiteColor] CGColor]];
        [_imageView3.layer setBorderWidth: borderWidth];
        _imageView3.clipsToBounds = YES;
        _imageView3.translatesAutoresizingMaskIntoConstraints = YES;
        _imageView3.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
        [self.contentView addSubview:_imageView3];
        
        // ImageView
        _imageView2 = [UIImageView new];
        _imageView2.contentMode = UIViewContentModeScaleAspectFill;
        _imageView2.frame = CGRectMake(kAlbumLeftToImageSpace+2, 8+2, kAlbumThumbnailSize2.width, kAlbumThumbnailSize2.height );
        [_imageView2.layer setBorderColor: [[UIColor whiteColor] CGColor]];
        [_imageView2.layer setBorderWidth: borderWidth];
        _imageView2.clipsToBounds = YES;
        _imageView2.translatesAutoresizingMaskIntoConstraints = YES;
        _imageView2.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
        [self.contentView addSubview:_imageView2];
        
        // ImageView
        _imageView1 = [UIImageView new];
        _imageView1.contentMode = UIViewContentModeScaleAspectFill;
        _imageView1.frame = CGRectMake(kAlbumLeftToImageSpace, 8+4, kAlbumThumbnailSize1.width, kAlbumThumbnailSize1.height );
        [_imageView1.layer setBorderColor: [[UIColor whiteColor] CGColor]];
        [_imageView1.layer setBorderWidth: borderWidth];
        _imageView1.clipsToBounds = YES;
        _imageView1.translatesAutoresizingMaskIntoConstraints = YES;
        _imageView1.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
        [self.contentView addSubview:_imageView1];
        
        
        // The video gradient, label & icon
        UIColor *topGradient = [UIColor colorWithRed:0.00 green:0.00 blue:0.00 alpha:0.0];
        UIColor *midGradient = [UIColor colorWithRed:0.00 green:0.00 blue:0.00 alpha:0.33];
        UIColor *botGradient = [UIColor colorWithRed:0.00 green:0.00 blue:0.00 alpha:0.75];
        _gradientView = [[UIView alloc] initWithFrame: CGRectMake(0.0f, kAlbumThumbnailSize1.height-kAlbumGradientHeight, kAlbumThumbnailSize1.width, kAlbumGradientHeight)];
        _gradient = [CAGradientLayer layer];
        _gradient.frame = _gradientView.bounds;
        _gradient.colors = [NSArray arrayWithObjects:(id)[topGradient CGColor], (id)[midGradient CGColor], (id)[botGradient CGColor], nil];
        _gradient.locations = @[ @0.0f, @0.5f, @1.0f ];
        [_gradientView.layer insertSublayer:_gradient atIndex:0];
        _gradientView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        _gradientView.translatesAutoresizingMaskIntoConstraints = YES;
        [self.imageView1 addSubview:_gradientView];
        _gradientView.hidden = YES;
        
        // VideoIcon
        _videoIcon = [UIImageView new];
        _videoIcon.contentMode = UIViewContentModeScaleAspectFill;
        _videoIcon.frame = CGRectMake(3,kAlbumThumbnailSize1.height - 4 - 8, 15, 8 );
        _videoIcon.image = [UIImage imageNamed:@"GMVideoIcon" inBundle:[NSBundle bundleForClass:GMAlbumsViewCell.class] compatibleWithTraitCollection:nil];
        _videoIcon.clipsToBounds = YES;
        _videoIcon.translatesAutoresizingMaskIntoConstraints = YES;
        _videoIcon.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
        [self.imageView1 addSubview:_videoIcon];
        _videoIcon.hidden = NO;

        // TextLabel
        self.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:17.0];
        self.textLabel.numberOfLines = 1;
        self.textLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.textLabel.adjustsFontSizeToFitWidth = YES;

        self.detailTextLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:14.0];
        self.detailTextLabel.numberOfLines = 1;
        self.detailTextLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.detailTextLabel.adjustsFontSizeToFitWidth = YES;
        
        // Set next text labels contraints :
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[imageView1]-(offset)-[textLabel]-|"
                                                                                 options:0
                                                                                 metrics:@{@"offset": @(kAlbumImageToTextSpace)}
                                                                                   views:@{@"textLabel": self.textLabel,
                                                                                           @"imageView1": self.imageView1}]];
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[imageView1]-(offset)-[detailTextLabel]-|"
                                                                                 options:0
                                                                                 metrics:@{@"offset": @(kAlbumImageToTextSpace)}
                                                                                   views:@{@"detailTextLabel": self.detailTextLabel,
                                                                                           @"imageView1": self.imageView1}]];
        
        
        [self.contentView addConstraints:@[[NSLayoutConstraint constraintWithItem:self.textLabel
                                                                        attribute:NSLayoutAttributeBottom
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self.textLabel.superview
                                                                        attribute:NSLayoutAttributeCenterY
                                                                       multiplier:1.f constant:0.f]]];
        
        [self.contentView addConstraints:@[[NSLayoutConstraint constraintWithItem:self.detailTextLabel
                                                                        attribute:NSLayoutAttributeTop
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self.textLabel.superview
                                                                        attribute:NSLayoutAttributeCenterY
                                                                       multiplier:1.f constant:+4.f]]];
    }
    
    
    
    return self;
}

- (void)setVideoLayout:(BOOL)isVideo
{
    // TODO : Add additional icons for slowmo, burst, etc...
    if (isVideo) {
        _videoIcon.hidden = NO;
        _gradientView.hidden = NO;
    } else {
        _videoIcon.hidden = YES;
        _gradientView.hidden = YES;
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
