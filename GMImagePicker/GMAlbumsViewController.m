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
@property (strong) NSArray *collectionsFetchResultsTitles;
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
    
    //Navigation bar customization_
    if(self.picker.customNavigationBarPrompt)
    {
        self.navigationItem.prompt = self.picker.customNavigationBarPrompt;
    }
    
    self.imageManager = [[PHCachingImageManager alloc] init];
    
    //Table view aspect
    self.tableView.rowHeight = kAlbumRowHeight;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    //Navigation bar items
    //if (self.picker.showsCancelButton)
    {
        self.navigationItem.leftBarButtonItem =
        [[UIBarButtonItem alloc] initWithTitle:NSLocalizedStringFromTable(@"picker.navigation.cancel-button", @"GMImagePicker",@"Cancel")
                                         style:UIBarButtonItemStylePlain
                                        target:self.picker
                                        action:@selector(dismiss:)];
    }
    
    self.navigationItem.rightBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:NSLocalizedStringFromTable(@"picker.navigation.done-button", @"GMImagePicker",@"Done")
                                     style:UIBarButtonItemStyleDone
                                    target:self.picker
                                    action:@selector(finishPickingAssets:)];
    
    self.navigationItem.rightBarButtonItem.enabled = (self.picker.selectedAssets.count > 0);
    
    //Bottom toolbar
    self.toolbarItems = self.picker.toolbarItems;
    
    //Title
    if (!self.picker.title)
        self.title = NSLocalizedStringFromTable(@"picker.navigation.title", @"GMImagePicker",@"Navigation bar default title");
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
    self.collectionsLocalizedTitles = @[NSLocalizedStringFromTable(@"picker.table.user-albums-header", @"GMImagePicker",@"Albums"), NSLocalizedStringFromTable(@"picker.table.smart-albums-header", @"GMImagePicker",@"Smart Albums")];
    
    [self updateFetchResults];
    
    //Register for changes
    [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];
}

- (void)dealloc
{
    [[PHPhotoLibrary sharedPhotoLibrary] unregisterChangeObserver:self];
}

-(void)updateFetchResults
{
    //What I do here is fetch both the albums list and the assets of each album.
    //This way I have acces to the number of items in each album, I can load the 3
    //thumbnails directly and I can pass the fetched result to the gridViewController.
    
    self.collectionsFetchResultsAssets=nil;
    self.collectionsFetchResultsTitles=nil;
    
    //Fetch PHAssetCollections:
    PHFetchResult *topLevelUserCollections = [self.collectionsFetchResults objectAtIndex:0];
    PHFetchResult *smartAlbums = [self.collectionsFetchResults objectAtIndex:1];
    
    //All album: Sorted by descending creation date.
    NSMutableArray *allFetchResultArray = [[NSMutableArray alloc] init];
    NSMutableArray *allFetchResultLabel = [[NSMutableArray alloc] init];
    {
        PHFetchOptions *options = [[PHFetchOptions alloc] init];
        options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
        //options.predicate = predicatePHAsset;
        PHFetchResult *assetsFetchResult = [PHAsset fetchAssetsWithOptions:options];
        [allFetchResultArray addObject:assetsFetchResult];
        [allFetchResultLabel addObject:NSLocalizedStringFromTable(@"picker.table.all-photos-label", @"GMImagePicker",@"All photos")];
    }
    
    //User albums:
    NSMutableArray *userFetchResultArray = [[NSMutableArray alloc] init];
    NSMutableArray *userFetchResultLabel = [[NSMutableArray alloc] init];
    for(PHCollection *collection in topLevelUserCollections)
    {
        if ([collection isKindOfClass:[PHAssetCollection class]])
        {
            //PHFetchOptions *options = [[PHFetchOptions alloc] init];
            //options.predicate = predicatePHAsset;
            PHAssetCollection *assetCollection = (PHAssetCollection *)collection;
            
            //Albums collections are allways PHAssetCollectionType=1 & PHAssetCollectionSubtype=2
            
            PHFetchResult *assetsFetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
            [userFetchResultArray addObject:assetsFetchResult];
            [userFetchResultLabel addObject:collection.localizedTitle];
        }
    }
    
                                  
    //Smart albums: Sorted by descending creation date.
    NSMutableArray *smartFetchResultArray = [[NSMutableArray alloc] init];
    NSMutableArray *smartFetchResultLabel = [[NSMutableArray alloc] init];
    for(PHCollection *collection in smartAlbums)
    {
        if ([collection isKindOfClass:[PHAssetCollection class]])
        {
            PHAssetCollection *assetCollection = (PHAssetCollection *)collection;
            
            //Smart collections are PHAssetCollectionType=2;
            if(self.picker.customSmartCollections && [self.picker.customSmartCollections containsObject:@(assetCollection.assetCollectionSubtype)])
            {
                PHFetchOptions *options = [[PHFetchOptions alloc] init];
                options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
                //options.predicate = predicatePHAsset;
                PHFetchResult *assetsFetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:options];
                if(assetsFetchResult.count>0)
                {
                    [smartFetchResultArray addObject:assetsFetchResult];
                    [smartFetchResultLabel addObject:collection.localizedTitle];
                }
            }
        }
    }
    
    self.collectionsFetchResultsAssets= @[allFetchResultArray,userFetchResultArray,smartFetchResultArray];
    self.collectionsFetchResultsTitles= @[allFetchResultLabel,userFetchResultLabel,smartFetchResultLabel];
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
    return self.collectionsFetchResultsAssets.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    PHFetchResult *fetchResult = self.collectionsFetchResultsAssets[section];
    return fetchResult.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    GMAlbumsViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[GMAlbumsViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    // Increment the cell's tag
    NSInteger currentTag = cell.tag + 1;
    cell.tag = currentTag;

    //Set the label
    cell.textLabel.text = (self.collectionsFetchResultsTitles[indexPath.section])[indexPath.row];
    
    //Retrieve the pre-fetched assets for this album:
    PHFetchResult *assetsFetchResult = (self.collectionsFetchResultsAssets[indexPath.section])[indexPath.row];
    
    //Display the number of assets
    if(self.picker.displayAlbumsNumberOfAssets)
    {
        cell.detailTextLabel.text = [self tableCellSubtitle:assetsFetchResult];
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
        // TO DO: Only preload the 3pixels height visible frame!
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
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    //Init the GMGridViewController
    GMGridViewController *gridViewController = [[GMGridViewController alloc] initWithPicker:[self picker]];
    //Set the title
    gridViewController.title = cell.textLabel.text;
    //Use the prefetched assets!
    gridViewController.assetsFetchResults = [[_collectionsFetchResultsAssets objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    //Push GMGridViewController
    [self.navigationController pushViewController:gridViewController animated:YES];
}

#pragma mark  Header

-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    
    //Here you can customize header views!
    header.textLabel.font = [UIFont systemFontOfSize:14.0f]; //Set font to "normal" style (default is bold) and to 14 pts.
    //header.textLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    //header.textLabel.textColor = [UIColor orangeColor];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    //Tip: Returning nil hides the section header!
    
    NSString *title = nil;
    if (section > 0)
    {
        //Only show title for non-empty sections:
        PHFetchResult *fetchResult = self.collectionsFetchResultsAssets[section];
        if( fetchResult.count >0)
        {
            title = self.collectionsLocalizedTitles[section - 1];
        }
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
        
        //This only affects to changes in albums level (add/remove/edit album)
        if (updatedCollectionsFetchResults)
        {
            self.collectionsFetchResults = updatedCollectionsFetchResults;
        }
        
        //However, we want to update if photos are added, so the counts of items & thumbnails are updated too.
        //Maybe some checks could be done here , but for now is OKey.
        [self updateFetchResults];
        [self.tableView reloadData];
        
    });
}



#pragma mark - Cell Subtitle

- (NSString *)tableCellSubtitle:(PHFetchResult*)assetsFetchResult
{
    //Just return the number of assets. Album app does this:
    return [NSString stringWithFormat:@"%ld", (long)[assetsFetchResult count]];
}



@end