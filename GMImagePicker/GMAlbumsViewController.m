//
//  GMAlbumsViewController.m
//  GMPhotoPicker
//
//  Created by Guillermo Muntaner Perelló on 19/09/14.
//  Copyright (c) 2014 Guillermo Muntaner Perelló. All rights reserved.
//

#import "GMImagePickerController.h"
#import "GMAlbumsViewController.h"
#import "GMGridViewCell.h"
#import "GMGridViewController.h"
#import "GMAlbumsViewCell.h"

@import Photos;

@interface GMAlbumsViewController() <PHPhotoLibraryChangeObserver>

@property (strong) NSArray *collectionsFetchResults;
@property (strong) NSArray *collectionsLocalizedTitles;
@property (strong) NSArray *collectionsFetchResultsAssets;
@property (nonatomic, weak) GMImagePickerController *picker;
@property (strong) PHCachingImageManager *imageManager;

@end


@implementation GMAlbumsViewController

- (id)init
{
    if (self = [super initWithStyle:UITableViewStylePlain])
    {
        self.preferredContentSize = kPopoverContentSize;
    }
    
    return self;
}

static NSString * const AllPhotosReuseIdentifier = @"AllPhotosCell";
static NSString * const CollectionCellReuseIdentifier = @"CollectionCell";

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.imageManager = [[PHCachingImageManager alloc] init];
    
    //Table view aspect
    self.tableView.rowHeight = kAlbumRowHeight;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    //Navigation bar items
    //if (self.picker.showsCancelButton)
    {
        self.navigationItem.leftBarButtonItem =
        [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Cancel", nil)
                                         style:UIBarButtonItemStylePlain
                                        target:self.picker
                                        action:@selector(dismiss:)];
    }
    
    self.navigationItem.rightBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Done", nil)
                                     style:UIBarButtonItemStyleDone
                                    target:self.picker
                                    action:@selector(finishPickingAssets:)];
    
    self.navigationItem.rightBarButtonItem.enabled = (self.picker.selectedAssets.count > 0);
    
    //Bottom toolbar
    self.toolbarItems = self.picker.toolbarItems;
    
    //Title
    if (!self.picker.title)
        self.title = NSLocalizedString(@"Photos", nil);
    else
        self.title = self.picker.title;
    

    // TO-DO Customizable predicates:
    // Predicate has to filter properties of the type of object returned by the PHFetchResult:
    // PHCollectionList, PHAssetCollection and PHAsset require different predicates
    // with limited posibilities (cannot filter a collection by mediaType for example)
    
    //NSPredicate *predicatePHCollectionList = [NSPredicate predicateWithFormat:@"(mediaType == %d)", PHAssetMediaTypeImage];
    //NSPredicate *predicatePHAssetCollection = [NSPredicate predicateWithFormat:@"(mediaType == %d)", PHAssetMediaTypeImage];
    //NSPredicate *predicatePHAsset = [NSPredicate predicateWithFormat:@"(mediaType == %d)", PHAssetMediaTypeImage];
    
    //Fetch PHAssetCollections:
    PHFetchResult *topLevelUserCollections = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];
    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    self.collectionsFetchResults = @[topLevelUserCollections, smartAlbums];
    self.collectionsLocalizedTitles = @[NSLocalizedString(@"Albums", @""), NSLocalizedString(@"Smart Albums", @"")];
    
    //All album: Sorted by descending creation date.
    NSMutableArray *allFetchResultArray = [[NSMutableArray alloc] init];
    {
        PHFetchOptions *options = [[PHFetchOptions alloc] init];
        options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
        //options.predicate = predicatePHAsset;
        PHFetchResult *assetsFetchResult = [PHAsset fetchAssetsWithOptions:options];
        [allFetchResultArray addObject:assetsFetchResult];
    }
    
    //User albums:
    NSMutableArray *userFetchResultArray = [[NSMutableArray alloc] init];
    for(PHCollection *collection in topLevelUserCollections)
    {
        if ([collection isKindOfClass:[PHAssetCollection class]])
        {
            //PHFetchOptions *options = [[PHFetchOptions alloc] init];
            //options.predicate = predicatePHAsset;
            PHAssetCollection *assetCollection = (PHAssetCollection *)collection;
            [userFetchResultArray addObject:[PHAsset fetchAssetsInAssetCollection:assetCollection options:nil]];
        }
    }

    
    //Smart albums: Sorted by descending creation date.
    NSMutableArray *smartFetchResultArray = [[NSMutableArray alloc] init];
    for(PHCollection *collection in smartAlbums)
    {
        if ([collection isKindOfClass:[PHAssetCollection class]])
        {
            PHAssetCollection *assetCollection = (PHAssetCollection *)collection;
            PHFetchOptions *options = [[PHFetchOptions alloc] init];
            options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
            //options.predicate = predicatePHAsset;
            [smartFetchResultArray addObject:[PHAsset fetchAssetsInAssetCollection:assetCollection options:options]];
        }
    }

    self.collectionsFetchResultsAssets= @[allFetchResultArray,userFetchResultArray,smartFetchResultArray];
    
    //Register for changes
    [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];
}

- (void)dealloc
{
    [[PHPhotoLibrary sharedPhotoLibrary] unregisterChangeObserver:self];
}


#pragma mark - Accessors

- (GMImagePickerController *)picker
{
    return (GMImagePickerController *)self.navigationController.parentViewController;
}


#pragma mark - Rotation

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //All photos + number of albums
    return 1 + self.collectionsFetchResults.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numberOfRows = 0;
    if (section == 0) {
        // "All Photos" section
        numberOfRows = 1;
    } else {
        // Albums sections
        PHFetchResult *fetchResult = self.collectionsFetchResults[section - 1];
        numberOfRows = fetchResult.count;
    }
    return numberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    NSString *localizedTitle = nil;
    NSString *localizedSubTitle = nil;
    
    GMAlbumsViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[GMAlbumsViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    // Increment the cell's tag
    NSInteger currentTag = cell.tag + 1;
    cell.tag = currentTag;
    
    //Retrieve the pre-fetched assets for this album:
    PHFetchResult *assetsFetchResult = (self.collectionsFetchResultsAssets[indexPath.section])[indexPath.row];
    
    //Set the labels:
    if (indexPath.section == 0)
    {
        localizedTitle = NSLocalizedString(@"All Photos", @"");
    }
    else
    {
        PHFetchResult *fetchResult = self.collectionsFetchResults[indexPath.section - 1];
        PHCollection *collection = fetchResult[indexPath.row];
        localizedTitle = collection.localizedTitle;
    }
    cell.textLabel.text = localizedTitle;
    
    
    //Display the number of assets
    if(self.picker.displayAlbumsNumberOfAssets)
    {
        localizedSubTitle = [self tableCellSubtitle:assetsFetchResult];
        cell.detailTextLabel.text = localizedSubTitle;
    }
    
    //Set the 3 images (if exists):
    if([assetsFetchResult count]>0)
    {
        CGFloat scale = [UIScreen mainScreen].scale;
        
        //Compute the thumbnail pixel size:
        CGSize tableCellThumbnailSize1 = CGSizeMake(kAlbumThumbnailSize1.width*scale, kAlbumThumbnailSize1.height*scale);
        PHAsset *asset = assetsFetchResult[0];
        [cell setVideoLayout:(asset.mediaType==PHAssetMediaTypeVideo)];
        [self.imageManager requestImageForAsset:asset
                                     targetSize:tableCellThumbnailSize1
                                    contentMode:PHImageContentModeAspectFill
                                        options:nil
                                  resultHandler:^(UIImage *result, NSDictionary *info)
         {
             if (cell.tag == currentTag)
             {
                 cell.imageView1.image = result;
             }
         }];
        
        //Second & third images:
        //TODO: Only preload the 3pixels height visible frame!
        if([assetsFetchResult count]>1)
        {
            //Compute the thumbnail pixel size:
            CGSize tableCellThumbnailSize2 = CGSizeMake(kAlbumThumbnailSize2.width*scale, kAlbumThumbnailSize2.height*scale);
            PHAsset *asset = assetsFetchResult[1];
            [self.imageManager requestImageForAsset:asset
                                         targetSize:tableCellThumbnailSize2
                                        contentMode:PHImageContentModeAspectFill
                                            options:nil
                                      resultHandler:^(UIImage *result, NSDictionary *info)
             {
                 if (cell.tag == currentTag)
                 {
                     cell.imageView2.image = result;
                 }
             }];
        }
        else
        {
            cell.imageView2.image = nil;
        }
        if([assetsFetchResult count]>2)
        {
            CGSize tableCellThumbnailSize3 = CGSizeMake(kAlbumThumbnailSize3.width*scale, kAlbumThumbnailSize3.height*scale);
            PHAsset *asset = assetsFetchResult[2];
            [self.imageManager requestImageForAsset:asset
                                         targetSize:tableCellThumbnailSize3
                                        contentMode:PHImageContentModeAspectFill
                                            options:nil
                                      resultHandler:^(UIImage *result, NSDictionary *info)
             {
                 if (cell.tag == currentTag)
                 {
                     cell.imageView3.image = result;
                 }
             }];
        }
        else
        {
            cell.imageView3.image = nil;
        }
        
        
        

        
    }
    else
    {
        [cell setVideoLayout:NO];
        cell.imageView3.image = [UIImage imageNamed:@"EmptyFolder"];
        cell.imageView2.image = [UIImage imageNamed:@"EmptyFolder"];
        cell.imageView1.image = [UIImage imageNamed:@"EmptyFolder"];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GMGridViewController *gridViewController = [[GMGridViewController alloc] initWithPicker:[self picker]];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    gridViewController.title = cell.textLabel.text;
    
    //All photos selected
    if (indexPath.section == 0 )
    {
        // Fetch all assets, sorted by date created.
        PHFetchOptions *options = [[PHFetchOptions alloc] init];
        options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
        gridViewController.assetsFetchResults = [PHAsset fetchAssetsWithOptions:options];
    }
    else
    {
        PHFetchResult *fetchResult = self.collectionsFetchResults[indexPath.section - 1];
        PHCollection *collection = fetchResult[indexPath.row];
        if ([collection isKindOfClass:[PHAssetCollection class]]) {
            PHAssetCollection *assetCollection = (PHAssetCollection *)collection;
            PHFetchResult *assetsFetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
            gridViewController.assetsFetchResults = assetsFetchResult;
            gridViewController.assetCollection = assetCollection;
        }

    }
    
    [self.navigationController pushViewController:gridViewController animated:YES];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *title = nil;
    if (section > 0) {
        title = self.collectionsLocalizedTitles[section - 1];
    }
    return title;
}


#pragma mark - PHPhotoLibraryChangeObserver

- (void)photoLibraryDidChange:(PHChange *)changeInstance
{
    // Call might come on any background queue. Re-dispatch to the main queue to handle it.
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSMutableArray *updatedCollectionsFetchResults = nil;
        
        for (PHFetchResult *collectionsFetchResult in self.collectionsFetchResults) {
            PHFetchResultChangeDetails *changeDetails = [changeInstance changeDetailsForFetchResult:collectionsFetchResult];
            if (changeDetails) {
                if (!updatedCollectionsFetchResults) {
                    updatedCollectionsFetchResults = [self.collectionsFetchResults mutableCopy];
                }
                [updatedCollectionsFetchResults replaceObjectAtIndex:[self.collectionsFetchResults indexOfObject:collectionsFetchResult] withObject:[changeDetails fetchResultAfterChanges]];
            }
        }
        
        if (updatedCollectionsFetchResults) {
            self.collectionsFetchResults = updatedCollectionsFetchResults;
            [self.tableView reloadData];
        }
        
    });
}



#pragma mark - Toolbar Title

- (NSString *)tableCellSubtitle:(PHFetchResult*)assetsFetchResult
{
    //Just return the number of assets. Album app does this:
    return [NSString stringWithFormat:@"%ld", (long)[assetsFetchResult count]];
    
    //A more customized way to return different texts depending on number of photos and videos:
    
    /*
    
    NSUInteger nImages = [assetsFetchResult countOfAssetsWithMediaType:PHAssetMediaTypeImage];
    NSUInteger nVideos = [assetsFetchResult countOfAssetsWithMediaType:PHAssetMediaTypeVideo];
    
    NSString *format;
    
    if(nImages>0 || nVideos>0)
    {
        if (nImages>0 && nVideos>0)
        {
            format = NSLocalizedString(@"%ld Items Selected", nil);
        }
        else if (nImages>0)
        {
            format = (nImages > 1) ? NSLocalizedString(@"%ld Photos", nil) : NSLocalizedString(@"%ld Photo", nil);
        }
        else if (nVideos>0)
        {
            format = (nVideos > 1) ? NSLocalizedString(@"%ld Videos", nil) : NSLocalizedString(@"%ld Video", nil);
        }
        return [NSString stringWithFormat:format, (long)[assetsFetchResult count]];
    }
    else
    {
        return NSLocalizedString(@"Album is empty", nil);
    }
     
    */
}



@end