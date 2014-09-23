/*
 CTAssetsGroupViewController.m
 
 The MIT License (MIT)
 
 Copyright (c) 2013 Clement CN Tsang
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 
 */

#import "GMImagePickerController.h"
#import "GMAlbumsViewController.h"
#import "GMGridViewCell.h"
#import "GMGridViewController.h"
#import "GMAlbumsViewCell.h"

@import Photos;

@interface GMAlbumsViewController() <PHPhotoLibraryChangeObserver>

@property (strong) NSArray *collectionsFetchResults;
@property (strong) NSArray *collectionsLocalizedTitles;
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
    self.tableView.rowHeight = kThumbnailLength + 12;
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
    
    
    //Fetch PHAssetCollections
    PHFetchResult *topLevelUserCollections = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];
    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    self.collectionsFetchResults = @[topLevelUserCollections, smartAlbums];
    self.collectionsLocalizedTitles = @[NSLocalizedString(@"Albums", @""), NSLocalizedString(@"Smart Albums", @"")];
    
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
    
    PHFetchResult *assetsFetchResult;
    //Set the labels:
    if (indexPath.section == 0)
    {
        localizedTitle = NSLocalizedString(@"All Photos", @"");
        assetsFetchResult = [PHAsset fetchAssetsWithOptions:nil];
    }
    else
    {
         PHFetchResult *fetchResult = self.collectionsFetchResults[indexPath.section - 1];
         PHCollection *collection = fetchResult[indexPath.row];
         localizedTitle = collection.localizedTitle;
        
         if ([collection isKindOfClass:[PHAssetCollection class]])
         {
             PHAssetCollection *assetCollection = (PHAssetCollection *)collection;
             assetsFetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
        }
    }
    cell.textLabel.text = localizedTitle;
    localizedSubTitle = [self tableCellSubtitle:assetsFetchResult];
    cell.detailTextLabel.text = localizedSubTitle;
    
    
    cell.imageView1.image = nil;
    cell.imageView2.image = nil;
    cell.imageView3.image = nil;
    
    //Set the image:
    if([assetsFetchResult count]>0)
    {
        if([assetsFetchResult count]>2)
        {
            //Compute the thumbnail pixel size:
            CGFloat scale = [UIScreen mainScreen].scale;
            CGSize tableCellThumbnailSize = CGSizeMake(kThumbnailSize.width * scale, kThumbnailSize.height * scale);
            
            PHAsset *asset = assetsFetchResult[2];
            [self.imageManager requestImageForAsset:asset
                                         targetSize:tableCellThumbnailSize
                                        contentMode:PHImageContentModeAspectFill
                                            options:nil
                                      resultHandler:^(UIImage *result, NSDictionary *info)
             {
                 // Only update the thumbnail if the cell tag hasn't changed. Otherwise, the cell has been re-used.
                 if (cell.tag == currentTag)
                 {
                     cell.imageView3.image = result;
                 }
             }];
        }
        if([assetsFetchResult count]>1)
        {
            //Compute the thumbnail pixel size:
            CGFloat scale = [UIScreen mainScreen].scale;
            CGSize tableCellThumbnailSize = CGSizeMake(kThumbnailSize.width * scale, kThumbnailSize.height * scale);
            
            PHAsset *asset = assetsFetchResult[1];
            [self.imageManager requestImageForAsset:asset
                                         targetSize:tableCellThumbnailSize
                                        contentMode:PHImageContentModeAspectFill
                                            options:nil
                                      resultHandler:^(UIImage *result, NSDictionary *info)
             {
                 // Only update the thumbnail if the cell tag hasn't changed. Otherwise, the cell has been re-used.
                 if (cell.tag == currentTag)
                 {
                     cell.imageView2.image = result;
                 }
             }];
        }
        //Compute the thumbnail pixel size:
        CGFloat scale = [UIScreen mainScreen].scale;
        CGSize tableCellThumbnailSize = CGSizeMake(kThumbnailSize.width * scale, kThumbnailSize.height * scale);
        
        PHAsset *asset = assetsFetchResult[0];
        [self.imageManager requestImageForAsset:asset
                                     targetSize:tableCellThumbnailSize
                                    contentMode:PHImageContentModeAspectFill
                                        options:nil
                                  resultHandler:^(UIImage *result, NSDictionary *info)
         {
             // Only update the thumbnail if the cell tag hasn't changed. Otherwise, the cell has been re-used.
             if (cell.tag == currentTag)
             {
                 cell.imageView1.image = result;
             }
         }];

        
    }
    else
    {
        cell.imageView1.image = [UIImage imageNamed:@"ImageSelectedOn"];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GMGridViewController *gridViewController = [[GMGridViewController alloc] initWithPicker:[self picker]];
    
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
    NSUInteger nImages = [assetsFetchResult countOfAssetsWithMediaType:PHAssetMediaTypeImage];
    NSUInteger nVideos = [assetsFetchResult countOfAssetsWithMediaType:PHAssetMediaTypeImage];
    
    NSString *format;
    
    if(nImages>0 || nVideos>0)
    {
        if (nImages>0 && nVideos>0)
        {
            format = NSLocalizedString(@"%ld Items Selected", nil);
        }
        else if (nImages>0)
        {
            format = (nImages > 1) ? NSLocalizedString(@"%ld Photos Selected", nil) : NSLocalizedString(@"%ld Photo Selected", nil);
        }
        else if (nVideos>0)
        {
            format = (nVideos > 1) ? NSLocalizedString(@"%ld Videos Selected", nil) : NSLocalizedString(@"%ld Video Selected", nil);
        }
        return [NSString stringWithFormat:format, (long)[assetsFetchResult count]];
    }
    else
    {
        return NSLocalizedString(@"Album is empty", nil);
    }
}



@end