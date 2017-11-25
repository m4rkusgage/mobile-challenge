//
//  MGGridCollectionViewController.m
//  500px-iOS
//
//  Created by Markus Gage on 2017-11-16.
//  Copyright © 2017 Mark Gage. All rights reserved.
//

#import "MGGridCollectionViewController.h"
#import "MGGridLayout.h"
#import "MGGridCollectionViewCell.h"
#import "MGApiClient.h"
#import "MGGalleryFullscreenCollectionViewController.h"
#import "MGLayoutDelegate.h"
#import "MGViewControllerDelegate.h"
#import "MGTransitionAnimator.h"

@interface MGGridCollectionViewController ()<MGLayoutDelegate, UINavigationControllerDelegate, MGViewControllerDelegate>
@property (assign, nonatomic) NSInteger pageNumer;
@property (strong, nonatomic) NSMutableArray *photoArray;
@property (strong, nonatomic) MGApiClient *apiClient;
@property (strong, nonatomic) NSIndexPath *currentSelectedIndex;
@property (strong, nonatomic) NSIndexPath *currentIndex;
@end

@implementation MGGridCollectionViewController

static NSString * const reuseIdentifier = @"GridCell";

- (MGApiClient *)apiClient {
    if (!_apiClient) {
        _apiClient = [MGApiClient sharedInstance];
    }
    return _apiClient;
}

- (NSMutableArray *)photoArray {
    if (!_photoArray) {
        _photoArray = [[NSMutableArray alloc] init];
    }
    return _photoArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setDelegate:self];
    [self.navigationController setNavigationBarHidden:YES];
    
    self.pageNumer = 1;
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"MGGridCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    
    [self.apiClient getListPhotosForFeature:kMG500pxPhotoFeaturePopular
                         includedCategories:@[]
                         excludedCategories:@[]
                                       page:self.pageNumer
                                 completion:^(NSArray *result, NSError *error) {
                                     self.photoArray = [result mutableCopy];
                                     [self.collectionView reloadData];
                                 }];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.photoArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    self.currentIndex = indexPath;
    MGPhoto *photo = self.photoArray[indexPath.item];
    
    MGGridCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    if (!photo.wasShown) {
        [cell reset];
    }
    
    if (photo.photoImage) {
        [cell setImage:photo.photoImage];
    } else {
        [self loadImageFor:photo forCell:cell atIndexPath:indexPath withCollectionView:collectionView];
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

#pragma mark <UICollectionViewDelegate>
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.currentSelectedIndex = indexPath;
    [self performSegueWithIdentifier:@"showFullscreen" sender:nil];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self loadImagesForOnScreenItems];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        [self loadImagesForOnScreenItems];
    }
}

#pragma mark - MGLayoutDelegate
- (CGSize)collectionView:(UICollectionView *)collectionView sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    MGGridLayout *gridLayout = (MGGridLayout *)collectionView.collectionViewLayout;
    MGPhoto *photo = self.photoArray[indexPath.item];
    
    CGFloat ratio = photo.photoDimension.height / gridLayout.preferredHeight;
    
    return CGSizeMake(photo.photoDimension.width/ratio, photo.photoDimension.height/ratio);
}

- (void)loadImageFor:(MGPhoto *)photo forCell:(MGGridCollectionViewCell *)gridCell atIndexPath:(NSIndexPath *)indexPath withCollectionView:(UICollectionView *)collectionView {
    
    gridCell.photoImageView.image = nil;
    NSURL *imageURL = [NSURL URLWithString:photo.photoURL];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSURLSessionTask *downloadTask = [session downloadTaskWithURL:imageURL completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        UIImage *img = [UIImage imageWithData:[NSData dataWithContentsOfURL:location]];
        photo.photoImage = img;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([collectionView indexPathForCell:gridCell].item == indexPath.item) {
                [gridCell setImage:img];
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
            MGGridCollectionViewCell *cell = (id)[self.collectionView cellForItemAtIndexPath:indexPath];
            if (photo.photoImage) {
                [cell setImage:photo.photoImage];
                photo.wasShown = YES;
            }
        }
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showFullscreen"]) {
        MGGalleryFullscreenCollectionViewController *fullscreenController = (MGGalleryFullscreenCollectionViewController *)[segue destinationViewController];
        
        fullscreenController.selectedIndexPath = self.currentSelectedIndex;
        fullscreenController.photoArray = self.photoArray;
        fullscreenController.pageNumer = self.pageNumer;
        [fullscreenController setControllerDelegate:self];
    }
}

#pragma mark - MGViewControllerDelegate
- (void)viewController:(UIViewController *)viewController didUpdateToIndexPath:(NSIndexPath *)indexPath {
    self.currentIndex = indexPath;
    [self.collectionView scrollToItemAtIndexPath:self.currentIndex atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:NO];
    [self.collectionView reloadItemsAtIndexPaths:@[self.currentIndex]];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    [self.collectionView scrollToItemAtIndexPath:self.currentIndex atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:NO];
    [self.collectionView reloadItemsAtIndexPaths:@[self.currentIndex]];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    return [[MGTransitionAnimator alloc] initWithOperation:operation];
}
@end
