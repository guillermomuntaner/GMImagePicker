//
//  GMAlbumsViewCell.m
//  GMPhotoPicker
//
//  Created by Guillermo Muntaner Perelló on 22/09/14.
//  Copyright (c) 2014 Guillermo Muntaner Perelló. All rights reserved.
//

#import "GMAlbumsViewCell.h"
#import "GMImagePickerController.h"
#import <QuartzCore/QuartzCore.h>

@implementation GMAlbumsViewCell
{
    int imageToLeftBorder;
    int labelToImageBorder;
}

static UIFont *titleFont;
static CGFloat titleHeight;
static UIImage *videoIcon;
static UIColor *titleColor;
static UIImage *checkedIcon;
static UIColor *selectedColor;
static UIColor *disabledColor;

+ (void)initialize
{
    titleFont       = [UIFont systemFontOfSize:12];
    titleHeight     = 20.0f;
    videoIcon       = [UIImage imageNamed:@"CTAssetsPickerVideo"];
    titleColor      = [UIColor whiteColor];
    checkedIcon     = [UIImage imageNamed:@"CTAssetsPickerChecked"];
    selectedColor   = [UIColor colorWithWhite:1 alpha:0.3];
    disabledColor   = [UIColor colorWithWhite:1 alpha:0.9];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.contentView.translatesAutoresizingMaskIntoConstraints = YES;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    imageToLeftBorder = 10;
    labelToImageBorder = 20;
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.opaque                             = YES;
        self.isAccessibilityElement             = YES;
        self.textLabel.backgroundColor          = self.backgroundColor;
        self.detailTextLabel.backgroundColor    = self.backgroundColor;
        
        //TextLabel
        self.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.textLabel.numberOfLines = 0;
        self.textLabel.translatesAutoresizingMaskIntoConstraints = NO;
        
        
        //ImageView
        _imageView3 = [UIImageView new];
        _imageView3.contentMode = UIViewContentModeScaleAspectFill;
        _imageView3.frame = CGRectMake(imageToLeftBorder+kThumbnailSize.height*0.05, 6, (kThumbnailSize.width-4)*0.9, (kThumbnailSize.height-4)*0.9);
        [_imageView3.layer setBorderColor: [[UIColor whiteColor] CGColor]];
        [_imageView3.layer setBorderWidth: 1.0];
        _imageView3.clipsToBounds = YES;
        _imageView3.translatesAutoresizingMaskIntoConstraints = NO;
        _imageView3.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
        [self.contentView addSubview:_imageView3];
        
        //ImageView
        _imageView2 = [UIImageView new];
        _imageView2.contentMode = UIViewContentModeScaleAspectFill;
        _imageView2.frame = CGRectMake(imageToLeftBorder+kThumbnailSize.height*0.025, 6+2, (kThumbnailSize.width-4)*0.95, (kThumbnailSize.height-4)*0.95);
        [_imageView2.layer setBorderColor: [[UIColor whiteColor] CGColor]];
        [_imageView2.layer setBorderWidth: 1.0];
        _imageView2.clipsToBounds = YES;
        _imageView2.translatesAutoresizingMaskIntoConstraints = NO;
        _imageView2.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
        [self.contentView addSubview:_imageView2];
        
        //ImageView
        _imageView1 = [UIImageView new];
        _imageView1.contentMode = UIViewContentModeScaleAspectFill;
        _imageView1.frame = CGRectMake(imageToLeftBorder, 6+4, (kThumbnailSize.width-4), (kThumbnailSize.height-4));
        [_imageView1.layer setBorderColor: [[UIColor whiteColor] CGColor]];
        [_imageView1.layer setBorderWidth: 1.0];
        _imageView1.clipsToBounds = YES;
        _imageView1.translatesAutoresizingMaskIntoConstraints = NO;
        _imageView1.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
        [self.contentView addSubview:_imageView1];
        
        //[self.contentView setNeedsLayout];
        //[self.contentView layoutIfNeeded];
    }
    
    return self;
}

//Required to resize the CAGradientLayer because it does not support auto resizing.
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect tmpFrame = self.textLabel.frame;
    tmpFrame.origin.x = imageToLeftBorder + (kThumbnailSize.width-4) + labelToImageBorder;
    self.textLabel.frame = tmpFrame;
    self.textLabel.bounds = tmpFrame;
    
    tmpFrame = self.detailTextLabel.frame;
    tmpFrame.origin.x = imageToLeftBorder + (kThumbnailSize.width-4) + labelToImageBorder;
    self.detailTextLabel.frame = tmpFrame;
    self.detailTextLabel.bounds = tmpFrame;
    
    // Make sure the contentView does a layout pass here so that its subviews have their frames set, which we
    // need to use to set the preferredMaxLayoutWidth below.
    [self.contentView setNeedsLayout];
    [self.contentView layoutIfNeeded];
    
    // Set the preferredMaxLayoutWidth of the mutli-line bodyLabel based on the evaluated width of the label's frame,
    // as this will allow the text to wrap correctly, and as a result allow the label to take on the correct height.
    self.textLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.textLabel.frame);
}

- (void)bindFetchResults:(PHFetchResult *)assetsFetchResults
{
    
}
- (void)bindAssetCollection:(PHAssetCollection *)assetCollection
{
    
}

- (void)setVideoLayout:(BOOL)isVideo
{
    if (isVideo)
    {
        _videoIcon.hidden = NO;
        _gradientView.hidden = NO;
    }
    else
    {
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
