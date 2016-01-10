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
 *  Determines which smart collections are displayed (int array of enum: PHAssetCollectionSubtypeSmartAlbum)
 *  The default smart collections are: 
 *  - Favorites
 *  - RecentlyAdded
 *  - Videos
 *  - SlomoVideos
 *  - Timelapses
 *  - Bursts
 *  - Panoramas
 */
@property (nonatomic, strong) NSArray* customSmartCollections;

/**
 *  Determines which media types are allowed (int array of enum: PHAssetMediaType)
 *  This defaults to all media types (view, audio and images)
 *  This can override customSmartCollections behavior (ie, remove video-only smart collections)
 */
@property (nonatomic, strong) NSArray* mediaTypes;

/**
 *  If set, it displays a this string instead of the localised default of "Done" on the done button. Note also that this
 *  is not used when a single selection is active since the selection of the chosen photo closes the VC thus rendering
 *  the button pointless.
 */
@property (nonatomic) NSString* customDoneButtonTitle;

/**
 *  If set, it displays this string instead of the localised default of "Cancel" on the cancel button
 */
@property (nonatomic) NSString* customCancelButtonTitle;

/**
 *  If set, it displays a prompt in the navigation bar
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
 *  Automatically disables the "Done" button if nothing is selected. Defaults to YES.
 */
@property (nonatomic, assign) BOOL autoDisableDoneButton;

/**
 *  Use the picker either for miltiple image selections, or just a single selection. In the case of a single selection
 *  the VC is closed on selection so the Done button is neither displayed or used. Default is YES.
 */
@property (nonatomic, assign) BOOL allowsMultipleSelection;

/**
 * In the case where allowsMultipleSelection = NO, set this to YES to have the user confirm their selection. Default is NO.
 */
@property (nonatomic, assign) BOOL confirmSingleSelection;

/**
 * If set, it displays this string (if confirmSingleSelection = YES) instead of the localised default.
 */
@property (nonatomic) NSString *confirmSingleSelectionPrompt;

/**
 *  True to always show the toolbar, with a camera button allowing new photos to be taken. False to auto show/hide the
 *  toolbar, and have no camera button. Default is false. If true, this renders displaySelectionInfoToolbar a no-op.
 */
@property (nonatomic, assign) BOOL showCameraButton;

/**
 * True to auto select the image(s) taken with the camera if showCameraButton = YES. In the case of allowsMultipleSelection = YES,
 * this will trigger the selection handler too.
 */
@property (nonatomic, assign) BOOL autoSelectCameraImages;

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

/**
 * UI customizations:
 *
 * - pickerBackgroundColor: The colour for all backgrounds; behind the table and cells. Defaults to [UIColor whiteColor]
 * - pickerTextColor: The color for text in the views. This needs to work with pickerBackgroundColor! Default of darkTextColor
 * - toolbarBarTintColor: The color for the background tint of the toolbar
 * - toolbarTextColor: The color of the text on the toolbar
 * - toolbarTintColor: The tint colour used for any buttons on the toolbar
 * - navigationBarBackgroundColor: The background of the navigation bar. Defaults to [UIColor whiteColor]
 * - navigationBarTextColor: The color for the text in the navigation bar. Defaults to [UIColor darkTextColor]
 * - navigationBarTintColor: The tint color used for any buttons on the navigation Bar
 * - pickerFontName: The font to use everywhere. Defaults to HelveticaNeue. It is advised if you set this to check, and possibly set, appropriately the custom font sizes. For font information, check http://www.iosfonts.com/
 * - pickerFontName: The font to use everywhere. Defaults to HelveticaNeue-Bold. It is advised if you set this to check, and possibly set, appropriately the custom font sizes.
 * - pickerFontNormalSize: The size of the custom font used in most places. Defaults to 14.0f
 * - pickerFontHeaderSize: The size of the custom font for album names. Defaults to 17.0f
 * - pickerStatusBarsStyle: On iPhones this will matter if custom navigation bar colours are being used. Defaults to UIStatusBarStyleDefault
 * - useCustomFontForNavigationBar: True to use the custom font (or it's default) in the navigation bar, false to leave to iOS Defaults.
 */
@property (nonatomic, strong) UIColor *pickerBackgroundColor;
@property (nonatomic, strong) UIColor *pickerTextColor;
@property (nonatomic, strong) UIColor *toolbarBarTintColor;
@property (nonatomic, strong) UIColor *toolbarTextColor;
@property (nonatomic, strong) UIColor *toolbarTintColor;
@property (nonatomic, strong) UIColor *navigationBarBackgroundColor;
@property (nonatomic, strong) UIColor *navigationBarTextColor;
@property (nonatomic, strong) UIColor *navigationBarTintColor;
@property (nonatomic, strong) NSString *pickerFontName;
@property (nonatomic, strong) NSString *pickerBoldFontName;
@property (nonatomic) CGFloat pickerFontNormalSize;
@property (nonatomic) CGFloat pickerFontHeaderSize;
@property (nonatomic) UIStatusBarStyle pickerStatusBarStyle;
@property (nonatomic) BOOL useCustomFontForNavigationBar;

/**
 * A reference to the navigation controller used to manage the whole picking process
 */
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