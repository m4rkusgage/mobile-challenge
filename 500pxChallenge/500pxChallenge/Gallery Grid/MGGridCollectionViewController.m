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

@interface MGGridCollectionViewController ()<MGGridLayoutDelegate>
@property (assign, nonatomic) NSInteger pageNumer;
@property (strong, nonatomic) NSMutableArray *photoArray;
@property (strong, nonatomic) MGApiClient *apiClient;
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
    
    MGGridCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    if (photo.photoImage) {
        cell.photoImageView.image = photo.photoImage;
    } else {
        cell.photoImageView.image = nil;
        [self loadImageFor:photo forImageView:cell.photoImageView];
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

- (CGSize)collectionView:(UICollectionView *)collectionView sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    MGGridLayout *gridLayout = (MGGridLayout *)collectionView.collectionViewLayout;
    MGPhoto *photo = self.photoArray[indexPath.item];
    
    CGFloat ratio = photo.photoDimension.height / gridLayout.preferredHeight;
    
    return CGSizeMake(photo.photoDimension.width/ratio, photo.photoDimension.height/ratio);
}

- (void)loadImageFor:(MGPhoto *)photo forImageView:(UIImageView *)imageView {
    NSURL *imageURL = [NSURL URLWithString:photo.photoURL];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSURLSessionTask *downloadTask = [session downloadTaskWithURL:imageURL completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        UIImage *img = [UIImage imageWithData:[NSData dataWithContentsOfURL:location]];
        photo.photoImage = img;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            imageView.image = img;
        });
    }];
    
    [downloadTask resume];
}

@end
