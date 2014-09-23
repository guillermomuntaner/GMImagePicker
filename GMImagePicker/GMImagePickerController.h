//
//  GMImagePickerController.h
//  GMPhotoPicker
//
//  Created by Guillermo Muntaner Perelló on 19/09/14.
//  Copyright (c) 2014 Guillermo Muntaner Perelló. All rights reserved.
//

@import UIKit;
@import Photos;

static CGFloat const kThumbnailLength = 78.0f;
static CGSize const kThumbnailSize = {kThumbnailLength, kThumbnailLength};
static CGSize const kPopoverContentSize = {320, 480};

@protocol GMImagePickerControllerDelegate;

// A controller that allows picking multiple photos and videos from user's photo library.
@interface GMImagePickerController : UIViewController

//The assets picker’s delegate object.
@property (nonatomic, weak) id <GMImagePickerControllerDelegate> delegate;

//The selected assets.
@property (nonatomic, strong) NSMutableArray *selectedAssets;

//Display a toolbar with the number of selected images and videos. YES by default. To hide it, set this property's value to NO.
@property (nonatomic) BOOL displaySelectionInfoToolbar;

//Grid configuration.
@property (nonatomic) NSInteger colsInPortrait;
@property (nonatomic) NSInteger colsInLandscape;
@property (nonatomic) double minimumInteritemSpacing;

/**
 *  @name Managing Selections
 */
- (void)selectAsset:(PHAsset *)asset;
- (void)deselectAsset:(PHAsset *)asset;

/**
 *  @name Managing Selections
 */
- (void)dismiss:(id)sender;
- (void)finishPickingAssets:(id)sender;

@end



@protocol GMImagePickerControllerDelegate <NSObject>

/**
 *  @name Closing the Picker
 */

/**
 *  Tells the delegate that the user finish picking photos or videos.
 *  @param picker The controller object managing the assets picker interface.
 *  @param assets An array containing picked PHAssets objects.
 */

- (void)assetsPickerController:(GMImagePickerController *)picker didFinishPickingAssets:(NSArray *)assets;


@optional

/**
 *  Tells the delegate that the user cancelled the pick operation.
 *  @param picker The controller object managing the assets picker interface.
 */
- (void)assetsPickerControllerDidCancel:(GMImagePickerController *)picker;


/**
 *  @name Enabling Assets
 */

/**
 *  Ask the delegate if the specified asset shoule be shown.
 *
 *  @param picker The controller object managing the assets picker interface.
 *  @param asset  The asset to be shown.
 *
 *  @return `YES` if the asset should be shown or `NO` if it should not.
 *
 *  @see [assetsFilter]([CTAssetsPickerController assetsFilter])
 *  @see assetsPickerController:shouldEnableAsset:
 */

- (BOOL)assetsPickerController:(GMImagePickerController *)picker shouldShowAsset:(PHAsset *)asset;

/**
 *  Ask the delegate if the specified asset should be enabled for selection.
 *
 *  @param picker The controller object managing the assets picker interface.
 *  @param asset  The asset to be enabled.
 *
 *  @return `YES` if the asset should be enabled or `NO` if it should not.
 *
 *  @see [assetsFilter]([CTAssetsPickerController assetsFilter])
 *  @see assetsPickerController:shouldShowAsset:
 */
- (BOOL)assetsPickerController:(GMImagePickerController *)picker shouldEnableAsset:(PHAsset *)asset;


/**
 *  @name Managing the Selected Assets
 */

/**
 *  Asks the delegate if the specified asset should be selected.
 *
 *  @param picker The controller object managing the assets picker interface.
 *  @param asset  The asset to be selected.
 *
 *  @return `YES` if the asset should be selected or `NO` if it should not.
 *
 */
- (BOOL)assetsPickerController:(GMImagePickerController *)picker shouldSelectAsset:(PHAsset *)asset;

/**
 *  Tells the delegate that the asset was selected.
 *
 *  @param picker    The controller object managing the assets picker interface.
 *  @param indexPath The asset that was selected.
 *
 */
- (void)assetsPickerController:(GMImagePickerController *)picker didSelectAsset:(PHAsset *)asset;

/**
 *  Asks the delegate if the specified asset should be deselected.
 *
 *  @param picker The controller object managing the assets picker interface.
 *  @param asset  The asset to be deselected.
 *
 *  @return `YES` if the asset should be deselected or `NO` if it should not.
 *
 */
- (BOOL)assetsPickerController:(GMImagePickerController *)picker shouldDeselectAsset:(PHAsset *)asset;

/**
 *  Tells the delegate that the item at the specified path was deselected.
 *
 *  @param picker    The controller object managing the assets picker interface.
 *  @param indexPath The asset that was deselected.
 *
 */
- (void)assetsPickerController:(GMImagePickerController *)picker didDeselectAsset:(PHAsset *)asset;



/**
 *  @name Managing Asset Highlighting
 */

/**
 *  Asks the delegate if the specified asset should be highlighted.
 *
 *  @param picker The controller object managing the assets picker interface.
 *  @param asset  The asset to be highlighted.
 *
 *  @return `YES` if the asset should be highlighted or `NO` if it should not.
 */
- (BOOL)assetsPickerController:(GMImagePickerController *)picker shouldHighlightAsset:(PHAsset *)asset;

/**
 *  Tells the delegate that asset was highlighted.
 *
 *  @param picker    The controller object managing the assets picker interface.
 *  @param indexPath The asset that was highlighted.
 *
 */
- (void)assetsPickerController:(GMImagePickerController *)picker didHighlightAsset:(PHAsset *)asset;


/**
 *  Tells the delegate that the highlight was removed from the asset.
 *
 *  @param picker    The controller object managing the assets picker interface.
 *  @param indexPath The asset that had its highlight removed.
 *
 */
- (void)assetsPickerController:(GMImagePickerController *)picker didUnhighlightAsset:(PHAsset *)asset;




@end