//
//  MGGalleryFullscreenCollectionViewController.m
//  500px-iOS
//
//  Created by Markus Gage on 2017-11-16.
//  Copyright © 2017 Mark Gage. All rights reserved.
//

#import "MGGalleryFullscreenCollectionViewController.h"
#import "MGGalleryFullscreenCollectionViewCell.h"
#import "MGHeaderCollectionReusableView.h"
#import "MGFooterCollectionReusableView.h"
#import "MGApiClient.h"
#import "MGFullscreenLayout.h"
#import "MGDescriptionTableViewController.h"

@interface MGGalleryFullscreenCollectionViewController ()<MGGalleryFullscreenCollectionViewCellDelegate, MGReusableViewDelegate, MGFullscreenLayoutDelegate, MGDescriptionViewControllerDelegate>
@property (assign, nonatomic) BOOL isFirstLoad;
@property (assign, nonatomic) BOOL showingReusableViews;
@property (assign, nonatomic) BOOL showingMoreInfo;
@property (strong, nonatomic) NSIndexPath *currentIndexPath;
@end

@implementation MGGalleryFullscreenCollectionViewController

static NSString * const reuseIdentifier = @"FullscreenCell";
static NSString * const reuseHeaderIdentifier = @"HeaderCell";
static NSString * const reuseFooterIdentifier = @"FooterCell";

- (MGApiClient *)apiClient {
    if (!_apiClient) {
        _apiClient = [MGApiClient sharedInstance];
    }
    return _apiClient;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.showingReusableViews = YES;
    if (self.selectedIndexPath.item > 1) {
        self.isFirstLoad = YES;
    }
    
    [self.collectionView setPagingEnabled:YES];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"MGGalleryFullscreenCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"MGHeaderCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuseHeaderIdentifier];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"MGFooterCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:reuseFooterIdentifier];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.collectionView scrollToItemAtIndexPath:self.selectedIndexPath atScrollPosition:UICollectionViewScrollPositionRight animated:NO];
    self.isFirstLoad = NO;
    [self updateFooterInfoWithPhoto:self.photoArray[self.selectedIndexPath.item]];
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

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        MGHeaderCollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuseHeaderIdentifier forIndexPath:indexPath];
        [header setReusableViewDelegate:self];
        return header;
    } else {
        MGFooterCollectionReusableView *footer = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:reuseFooterIdentifier forIndexPath:indexPath];
        [footer setReusableViewDelegate:self];
        return footer;
    }
    
    return [UICollectionReusableView new];
}

- (void)fullscreenCell:(MGGalleryFullscreenCollectionViewCell *)cell inUse:(BOOL)isActive {
    if (isActive) {
        [self.collectionView setScrollEnabled:NO];
    } else {
        [self.collectionView setScrollEnabled:YES];
    }
}

- (void)fullscreenCellWasTapped:(MGGalleryFullscreenCollectionViewCell *)cell {
    MGHeaderCollectionReusableView *header = (MGHeaderCollectionReusableView *)[self.collectionView  supplementaryViewForElementKind:UICollectionElementKindSectionHeader atIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    MGFooterCollectionReusableView *footer = (MGFooterCollectionReusableView *)[self.collectionView  supplementaryViewForElementKind:UICollectionElementKindSectionFooter atIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    
    if (self.showingReusableViews) {
        self.showingReusableViews = NO;
        [UIView animateWithDuration:0.5 animations:^{
            header.alpha = 0;
            footer.alpha = 0;
        }];
    } else {
        self.showingReusableViews = YES;
        [UIView animateWithDuration:0.5 animations:^{
            header.alpha = 1;
            footer.alpha = 1;
        }];
    }
}

- (CGFloat)collectionViewCurrentAlpha:(UICollectionView *)collectionView {
    return self.showingReusableViews;
}

- (CGSize)collectionViewSizeOfFooterView:(UICollectionView *)collectionView {
    return CGSizeMake(self.collectionView.bounds.size.width, 125);
}

- (void)updateFooterInfoWithPhoto:(MGPhoto *)photo {
   MGFooterCollectionReusableView *footer = (MGFooterCollectionReusableView *)[self.collectionView  supplementaryViewForElementKind:UICollectionElementKindSectionFooter atIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    
    [footer.titleLabel setText:photo.photoTitle];
    [footer.authorNameLabel setText:photo.user.userFullName];
    [footer.createdAtLabel setText:[self timeIntervalFrom:photo.createdAt]];
    
    [footer.likeCountLabel setText:photo.likedCount];
    [footer.viewedCountLabel setText:photo.viewedCount];
    [footer.commentCountLabel setText:photo.commentedCount];
}

- (NSString *)timeIntervalFrom:(NSString *)createdDate {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
        [dateFormatter setLocale:usLocale];
        [dateFormatter setDateStyle:NSDateFormatterLongStyle];
        [dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
        [dateFormatter setDateFormat: @"yyyy-MM-dd'T'HH:mm:ssZ"];
        
        NSDate *date = [dateFormatter dateFromString:createdDate];
        NSDate *now = [NSDate date];
        
        NSTimeInterval seconds = [now timeIntervalSinceDate:date];
        
        if(seconds < 60) {
            return [[NSString alloc] initWithFormat:@"%.0f seconds ago", seconds];
        }
        else if(seconds < 3600) {
            return [[NSString alloc] initWithFormat:@"%.0f minutes ago", seconds/60];
        }
        else if(seconds < 3600 * 24) {
            return [[NSString alloc] initWithFormat:@"%.0f hours ago", seconds/3600];
        }
        else if(seconds < 3600 * 24 * 365) {
            return [[NSString alloc] initWithFormat:@"%.0f days ago", seconds/3600/24];
        }
        else {
            return [[NSString alloc] initWithFormat:@"%.0f years ago", seconds/3600/24/365];
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
            self.currentIndexPath = indexPath;
            MGPhoto *photo = self.photoArray[indexPath.item];
            [self updateFooterInfoWithPhoto:photo];
            MGGalleryFullscreenCollectionViewCell *cell = (id)[self.collectionView cellForItemAtIndexPath:indexPath];
            if (photo.photoImage) {
                [cell setImage:photo.photoImage];
                photo.wasShown = YES;
            }
        }
    }
}

- (void)reusableView:(UICollectionReusableView *)reusableView buttonPressed:(ReusableViewButton)buttonType {
    switch (buttonType) {
        case ReusableViewButtonClose:{
            [self.navigationController popViewControllerAnimated:YES];
            break;
        }
            
        case ReusableViewButtonInfo:{
            if (self.showingReusableViews) {
                [self fullscreenCellWasTapped:nil];
            }
            [self performSegueWithIdentifier:@"showDescriptionInfo" sender:nil];
            break;
        }
        default:
            break;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDescriptionInfo"]) {
        MGDescriptionTableViewController *descriptionController = (MGDescriptionTableViewController *)[segue destinationViewController];
        descriptionController.photo = self.photoArray[self.currentIndexPath.item];
        descriptionController.controllerDelegate = self;
    }
}

- (void)viewControllerDidClose:(UIViewController *)viewController {
     [self fullscreenCellWasTapped:nil];
}
@end
