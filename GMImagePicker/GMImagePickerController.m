//
//  GMImagePickerController.m
//  GMPhotoPicker
//
//  Created by Guillermo Muntaner Perelló on 19/09/14.
//  Copyright (c) 2014 Guillermo Muntaner Perelló. All rights reserved.
//

#import "GMImagePickerController.h"
#import "GMAlbumsViewController.h"
@import Photos;

@interface GMImagePickerController () <UINavigationControllerDelegate>

@end

@implementation GMImagePickerController

- (id)init
{
    if (self = [super init])
    {
        _selectedAssets = [[NSMutableArray alloc] init];
        
        //Default values:
        _displaySelectionInfoToolbar = YES;
        _displayAlbumsNumberOfAssets = YES;
        _autoDisableDoneButton = YES;
        
        //Grid configuration:
        _colsInPortrait = 3;
        _colsInLandscape = 5;
        _minimumInteritemSpacing = 2.0;
        
        //Sample of how to select the collections you want to display:
        _customSmartCollections = @[@(PHAssetCollectionSubtypeSmartAlbumFavorites),
                                    @(PHAssetCollectionSubtypeSmartAlbumRecentlyAdded),
                                    @(PHAssetCollectionSubtypeSmartAlbumVideos),
                                    @(PHAssetCollectionSubtypeSmartAlbumSlomoVideos),
                                    @(PHAssetCollectionSubtypeSmartAlbumTimelapses),
                                    @(PHAssetCollectionSubtypeSmartAlbumBursts),
                                    @(PHAssetCollectionSubtypeSmartAlbumPanoramas)];
        //If you don't want to show smart collections, just put _customSmartCollections to nil;
        //_customSmartCollections=nil;
        
        //Which media types will display
        _mediaTypes = @[@(PHAssetMediaTypeAudio),
                        @(PHAssetMediaTypeVideo),
                        @(PHAssetMediaTypeImage)];
        
        self.preferredContentSize = kPopoverContentSize;
        
        [self setupNavigationController];
    }
    return self;
}

- (void)dealloc
{
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Setup Navigation Controller

- (void)setupNavigationController
{
    GMAlbumsViewController *albumsViewController = [[GMAlbumsViewController alloc] init];
    _navigationController = [[UINavigationController alloc] initWithRootViewController:albumsViewController];
    _navigationController.delegate = self;
    
    [_navigationController willMoveToParentViewController:self];
    [_navigationController.view setFrame:self.view.frame];
    [self.view addSubview:_navigationController.view];
    [self addChildViewController:_navigationController];
    [_navigationController didMoveToParentViewController:self];
}

#pragma mark - Select / Deselect Asset

- (void)selectAsset:(PHAsset *)asset
{
    [self.selectedAssets insertObject:asset atIndex:self.selectedAssets.count];
    [self updateDoneButton];
    
    if(self.displaySelectionInfoToolbar)
        [self updateToolbar];
}

- (void)deselectAsset:(PHAsset *)asset
{
    [self.selectedAssets removeObjectAtIndex:[self.selectedAssets indexOfObject:asset]];
    if(self.selectedAssets.count == 0)
        [self updateDoneButton];
    
    if(self.displaySelectionInfoToolbar)
        [self updateToolbar];
}

- (void)updateDoneButton
{
    UINavigationController *nav = (UINavigationController *)self.childViewControllers[0];
    for (UIViewController *viewController in nav.viewControllers)
        viewController.navigationItem.rightBarButtonItem.enabled = (self.autoDisableDoneButton ? self.selectedAssets.count > 0 : TRUE);
}

- (void)updateToolbar
{
    UINavigationController *nav = (UINavigationController *)self.childViewControllers[0];
    for (UIViewController *viewController in nav.viewControllers)
    {
        [[viewController.toolbarItems objectAtIndex:1] setTitle:[self toolbarTitle]];
        [viewController.navigationController setToolbarHidden:(self.selectedAssets.count == 0) animated:YES];
    }
}

#pragma mark - User finish Actions

- (void)dismiss:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(assetsPickerControllerDidCancel:)])
        [self.delegate assetsPickerControllerDidCancel:self];
    
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}


- (void)finishPickingAssets:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(assetsPickerController:didFinishPickingAssets:)])
        [self.delegate assetsPickerController:self didFinishPickingAssets:self.selectedAssets];
    
    //[self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Toolbar Title

- (NSPredicate *)predicateOfAssetType:(PHAssetMediaType)type
{
    return [NSPredicate predicateWithBlock:^BOOL(PHAsset *asset, NSDictionary *bindings) {
        return (asset.mediaType==type);
    }];
}

- (NSString *)toolbarTitle
{
    if (self.selectedAssets.count == 0)
        return nil;
    
    NSPredicate *photoPredicate = [self predicateOfAssetType:PHAssetMediaTypeImage];
    NSPredicate *videoPredicate = [self predicateOfAssetType:PHAssetMediaTypeVideo];
    
    NSInteger nImages = [self.selectedAssets filteredArrayUsingPredicate:photoPredicate].count;
    NSInteger nVideos = [self.selectedAssets filteredArrayUsingPredicate:videoPredicate].count;
    
    if (nImages>0 && nVideos>0)
    {
        return [NSString stringWithFormat:NSLocalizedStringFromTableInBundle(@"picker.selection.multiple-items",  @"GMImagePicker", [NSBundle bundleForClass:GMImagePickerController.class],  @"%@ Items Selected" ), @(nImages+nVideos)];
    }
    else if (nImages>1)
    {
        return [NSString stringWithFormat:NSLocalizedStringFromTableInBundle(@"picker.selection.multiple-photos",  @"GMImagePicker", [NSBundle bundleForClass:GMImagePickerController.class],  @"%@ Photos Selected"), @(nImages)];
    }
    else if (nImages==1)
    {
        return NSLocalizedStringFromTableInBundle(@"picker.selection.single-photo",  @"GMImagePicker", [NSBundle bundleForClass:GMImagePickerController.class],  @"1 Photo Selected" );
    }
    else if (nVideos>1)
    {
        return [NSString stringWithFormat:NSLocalizedStringFromTableInBundle(@"picker.selection.multiple-videos",  @"GMImagePicker", [NSBundle bundleForClass:GMImagePickerController.class],  @"%@ Videos Selected"), @(nVideos)];
    }
    else if (nVideos==1)
    {
        return NSLocalizedStringFromTableInBundle(@"picker.selection.single-video",  @"GMImagePicker", [NSBundle bundleForClass:GMImagePickerController.class],  @"1 Video Selected");
    }
    else
    {
        return nil;
    }
}


#pragma mark - Toolbar Items

- (UIBarButtonItem *)titleButtonItem
{
    UIBarButtonItem *title =
    [[UIBarButtonItem alloc] initWithTitle:self.toolbarTitle
                                     style:UIBarButtonItemStylePlain
                                    target:nil
                                    action:nil];
    
    NSDictionary *attributes = @{NSForegroundColorAttributeName : [UIColor blackColor]};
    
    [title setTitleTextAttributes:attributes forState:UIControlStateNormal];
    [title setTitleTextAttributes:attributes forState:UIControlStateDisabled];
    [title setEnabled:NO];
    
    return title;
}

- (UIBarButtonItem *)spaceButtonItem
{
    return [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
}

- (NSArray *)toolbarItems
{
    UIBarButtonItem *title = [self titleButtonItem];
    UIBarButtonItem *space = [self spaceButtonItem];
    
    return @[space, title, space];
}


@end
