//
//  MGGalleryFullscreenCollectionViewController.m
//  500px-iOS
//
//  Created by Markus Gage on 2017-11-16.
//  Copyright © 2017 Mark Gage. All rights reserved.
//

#import "MGGalleryFullscreenCollectionViewController.h"
#import "MGGalleryFullscreenCollectionViewCell.h"
#import "MGApiClient.h"

@interface MGGalleryFullscreenCollectionViewController ()<MGGalleryFullscreenCollectionViewCellDelegate>
@property (assign, nonatomic) BOOL isFirstLoad;
@property (strong, nonatomic) NSIndexPath *currentIndexPath;
@end

@implementation MGGalleryFullscreenCollectionViewController

static NSString * const reuseIdentifier = @"FullscreenCell";

- (MGApiClient *)apiClient {
    if (!_apiClient) {
        _apiClient = [MGApiClient sharedInstance];
    }
    return _apiClient;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isFirstLoad = YES;
    [self.collectionView setPagingEnabled:YES];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"MGGalleryFullscreenCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    CGRect rect = [self.collectionView layoutAttributesForItemAtIndexPath:self.selectedIndexPath].frame;
    [self.collectionView scrollRectToVisible:rect animated:NO];
    self.isFirstLoad = NO;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    if (![self.navigationController.viewControllers containsObject:self]) {
        [self.controllerDelegate viewController:self
                                      didUpdate:self.photoArray
                                    currentPage:self.pageNumer
                                 onCurrentIndex:self.currentIndexPath];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.photoArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    self.currentIndexPath = indexPath;
    MGPhoto *photo = self.photoArray[indexPath.item];
    
    MGGalleryFullscreenCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    [cell setCellDelegate:self];
    
    if (!photo.wasShown) {
        [cell reset];
    }
    
    if (!self.isFirstLoad) {
        if (photo.photoImage) {
            [cell setImage:photo.photoImage];
        } else {
            [self loadImageFor:photo forCell:cell atIndexPath:indexPath withCollectionView:collectionView];
        }
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item == [self.photoArray count] - 5) {
        self.pageNumer += 1;
        [self.apiClient getListPhotosForFeature:kMG500pxPhotoFeaturePopular
                             includedCategories:@[]
                             excludedCategories:@[]
                                           page:self.pageNumer
                                     completion:^(NSArray *result, NSError *error) {
                                         [self.photoArray addObjectsFromArray:result];
                                         [self.collectionView reloadData];
                                     }];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self loadImagesForOnScreenItems];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        [self loadImagesForOnScreenItems];
    }
}


#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

- (void)fullscreenCell:(MGGalleryFullscreenCollectionViewCell *)cell inUse:(BOOL)isActive {
    if (isActive) {
        [self.collectionView setScrollEnabled:NO];
    } else {
        [self.collectionView setScrollEnabled:YES];
    }
}

- (void)loadImageFor:(MGPhoto *)photo forCell:(MGGalleryFullscreenCollectionViewCell *)fullscreenCell atIndexPath:(NSIndexPath *)indexPath withCollectionView:(UICollectionView *)collectionView {
    
    fullscreenCell.photoImageView.image = nil;
    NSURL *imageURL = [NSURL URLWithString:photo.photoURL];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSURLSessionTask *downloadTask = [session downloadTaskWithURL:imageURL completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        UIImage *img = [UIImage imageWithData:[NSData dataWithContentsOfURL:location]];
        photo.photoImage = img;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([collectionView indexPathForCell:fullscreenCell].item == indexPath.item) {
                [fullscreenCell setImage:img];
                photo.wasShown = YES;
            }
        });
    }];
    
    [downloadTask resume];
}

- (void)loadImagesForOnScreenItems {
    if ([self.photoArray count]) {
        NSArray *visiblePaths = [self.collectionView indexPathsForVisibleItems];
        for (NSIndexPath *indexPath in visiblePaths) {
            MGPhoto *photo = self.photoArray[indexPath.item];
            MGGalleryFullscreenCollectionViewCell *cell = (id)[self.collectionView cellForItemAtIndexPath:indexPath];
            if (photo.photoImage) {
                [cell setImage:photo.photoImage];
                photo.wasShown = YES;
            }
        }
    }
}
@end
