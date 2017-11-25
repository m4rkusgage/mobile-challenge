//
//  MGGalleryFullscreenCollectionViewController.m
//  500px-iOS
//
//  Created by Markus Gage on 2017-11-16.
//  Copyright © 2017 Mark Gage. All rights reserved.
//

#import "MGGalleryFullscreenCollectionViewController.h"
#import "MGDescriptionTableViewController.h"
#import "MGGalleryFullscreenCollectionViewCell.h"
#import "MGHeaderCollectionReusableView.h"
#import "MGFooterCollectionReusableView.h"
#import "MGFullscreenLayout.h"
#import "MGTransitionAnimator.h"
#import "NSString+MGUtilities.h"

@interface MGGalleryFullscreenCollectionViewController ()<MGCellDelegate, MGReusableViewDelegate, MGLayoutDelegate, MGViewControllerDelegate>
@property (assign, nonatomic) BOOL showingReusableViews;
@property (assign, nonatomic) NSInteger currentNumberOfItems;
@end

@implementation MGGalleryFullscreenCollectionViewController

static NSString * const reuseIdentifier = @"FullscreenCell";
static NSString * const reuseHeaderIdentifier = @"HeaderCell";
static NSString * const reuseFooterIdentifier = @"FooterCell";

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self.collectionView setPagingEnabled:YES];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"MGGalleryFullscreenCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    [self.collectionView registerNib:[UINib nibWithNibName:@"MGHeaderCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuseHeaderIdentifier];
    [self.collectionView registerNib:[UINib nibWithNibName:@"MGFooterCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:reuseFooterIdentifier];
    
    self.showingReusableViews = YES;
    self.currentNumberOfItems = [self.photoArray count];
    
    [self.collectionView scrollToItemAtIndexPath:self.currentIndexPath atScrollPosition:UICollectionViewScrollPositionRight animated:NO];
    [self updateFooterInfoWithPhoto:self.photoArray[self.currentIndexPath.item]];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self updateFooterInfoWithPhoto:self.photoArray[self.currentIndexPath.item]];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    if (![self.navigationController.viewControllers containsObject:self]) {
        [self.controllerDelegate viewControllerDidClose:self];
    }
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.currentNumberOfItems;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MGPhoto *photo = self.photoArray[indexPath.item];
    
    MGGalleryFullscreenCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    [cell setCellDelegate:self];
    
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

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item == self.currentNumberOfItems - 2) {
        dispatch_async(dispatch_get_global_queue(NSQualityOfServiceBackground, 0), ^{
            self.currentNumberOfItems = [self.photoArray count];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.collectionView reloadData];
            });
        }); 
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self loadImagesForOnScreenItems];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        [self loadImagesForOnScreenItems];
    }
}

#pragma mark - MGCellDelegate
- (void)collectionViewCell:(UICollectionViewCell *)cell isInteractedWith:(BOOL)interacted {
    [self.collectionView setScrollEnabled:!interacted];
}

- (void)collectionViewCell:(UICollectionViewCell *)cell isSelected:(BOOL)selected {
    [self displayReusableViews:selected];
}

#pragma mark - MGLayoutDelegate
- (CGSize)collectionView:(UICollectionView *)collectionView sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.collectionView.bounds.size;
}

- (CGSize)collectionView:(UICollectionView *)collectionView sizeForSupplementaryElementKind:(NSString *)kind AtIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        return CGSizeMake(CGRectGetWidth(self.collectionView.bounds), 70);
    } else if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        return CGSizeMake(CGRectGetWidth(self.collectionView.bounds), 125);
    }
    return CGSizeZero;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView alphaForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.showingReusableViews;
}

#pragma mark - Helper Methods
- (void)displayReusableViews:(BOOL)isDisplayed {
    self.showingReusableViews = !isDisplayed;
    MGHeaderCollectionReusableView *header = (MGHeaderCollectionReusableView *)[self.collectionView  supplementaryViewForElementKind:UICollectionElementKindSectionHeader atIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    MGFooterCollectionReusableView *footer = (MGFooterCollectionReusableView *)[self.collectionView  supplementaryViewForElementKind:UICollectionElementKindSectionFooter atIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    
    [UIView animateWithDuration:0.25 animations:^{
        header.alpha = self.showingReusableViews;
        footer.alpha = self.showingReusableViews;
    }];
}

- (void)updateFooterInfoWithPhoto:(MGPhoto *)photo {
   MGFooterCollectionReusableView *footer = (MGFooterCollectionReusableView *)[self.collectionView  supplementaryViewForElementKind:UICollectionElementKindSectionFooter atIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    
    [footer.titleLabel setText:photo.photoTitle];
    [footer.authorNameLabel setText:photo.user.userFullName];
    [footer.createdAtLabel setText:[NSString stringByTimeIntervalFromDateString:photo.createdAt]];
    
    [footer.likeCountLabel setText:photo.likedCount];
    [footer.viewedCountLabel setText:photo.viewedCount];
    [footer.commentCountLabel setText:photo.commentedCount];
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
            [self.controllerDelegate viewController:self didUpdateToIndexPath:indexPath];
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

#pragma mark - Notifiers
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDescriptionInfo"]) {
        MGDescriptionTableViewController *descriptionController = (MGDescriptionTableViewController *)[segue destinationViewController];
        descriptionController.photo = self.photoArray[self.currentIndexPath.item];
        descriptionController.controllerDelegate = self;
    }
}

#pragma mark - MGReusableViewDelegate
- (void)reusableView:(UICollectionReusableView *)reusableView buttonPressed:(ReusableViewButton)buttonType {
    switch (buttonType) {
        case ReusableViewButtonClose:{
            [self.navigationController popViewControllerAnimated:YES];
            break;
        }
            
        case ReusableViewButtonInfo:{
            [self displayReusableViews:self.showingReusableViews];
            [self performSegueWithIdentifier:@"showDescriptionInfo" sender:nil];
            break;
        }
        default:
            break;
    }
}

#pragma mark - MGViewControllerDelegate
- (void)viewControllerDidClose:(UIViewController *)viewController {
    [self displayReusableViews:self.showingReusableViews];
}

@end
