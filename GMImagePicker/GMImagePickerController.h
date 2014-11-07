//
//  GMImagePickerController.h
//  GMPhotoPicker
//
//  Created by Guillermo Muntaner Perelló on 19/09/14.
//  Copyright (c) 2014 Guillermo Muntaner Perelló. All rights reserved.
//

@import UIKit;
@import Photos;


//This is the default image picker size!
//static CGSize const kPopoverContentSize = {320, 480};
//However, the iPad is 1024x768 so it can allow popups up to 768!
static CGSize const kPopoverContentSize = {480, 720};


@protocol GMImagePickerControllerDelegate;


/**
 *  A controller that allows picking multiple photos and videos from user's photo library.
 */
@interface GMImagePickerController : UIViewController

/**
 *  The assets picker’s delegate object.
 */
@property (nonatomic, weak) id <GMImagePickerControllerDelegate> delegate;

/**
 *  It contains the selected `PHAsset` objects. The order of the objects is the selection order.
 *
 *  You can add assets before presenting the picker to show the user some preselected assets.
 */
@property (nonatomic, strong) NSMutableArray *selectedAssets;


/** UI Customizations **/

/**
 *  Determines whether or not the number of assets is shown in the Album list.
 *  The number of assets is visible by default.
 */
@property (nonatomic, strong) NSArray* customSmartCollections;

/**
 *  If set, it displays a promt in the navigation bar
 */
@property (nonatomic) NSString* customNavigationBarPrompt;

/**
 *  Determines whether or not a toolbar with info about user selection is shown.
 *  The InfoToolbar is visible by default.
 */
@property (nonatomic) BOOL displaySelectionInfoToolbar;

/**
 *  Determines whether or not the number of assets is shown in the Album list.
 *  The number of assets is visible by default.
 */
@property (nonatomic, assign) BOOL displayAlbumsNumberOfAssets;

/**
 *  Grid customizations:
 *
 *  - colsInPortrait: Number of columns in portrait (3 by default)
 *  - colsInLandscape: Number of columns in landscape (5 by default)
 *  - minimumInteritemSpacing: Horizontal and vertical minimum space between grid cells (2.0 by default)
 */
@property (nonatomic) NSInteger colsInPortrait;
@property (nonatomic) NSInteger colsInLandscape;
@property (nonatomic) double minimumInteritemSpacing;


@property (nonatomic, strong) UINavigationController *navigationController;

/**
 *  Managing Asset Selection
 */
- (void)selectAsset:(PHAsset *)asset;
- (void)deselectAsset:(PHAsset *)asset;

/**
 *  User finish Actions
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
 *  Ask the delegate if the specified asset should be shown.
 *
 *  @param picker The controller object managing the assets picker interface.
 *  @param asset  The asset to be shown.
 *
 *  @return `YES` if the asset should be shown or `NO` if it should not.
 */

- (BOOL)assetsPickerController:(GMImagePickerController *)picker shouldShowAsset:(PHAsset *)asset;

/**
 *  Ask the delegate if the specified asset should be enabled for selection.
 *
 *  @param picker The controller object managing the assets picker interface.
 *  @param asset  The asset to be enabled.
 *
 *  @return `YES` if the asset should be enabled or `NO` if it should not.
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