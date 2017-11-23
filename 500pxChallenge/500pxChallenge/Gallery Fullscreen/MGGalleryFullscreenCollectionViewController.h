//
//  MGGalleryFullscreenCollectionViewController.h
//  500px-iOS
//
//  Created by Markus Gage on 2017-11-16.
//  Copyright © 2017 Mark Gage. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGApiClient.h"

@class MGGalleryFullscreenCollectionViewController;

@protocol MGGalleryFullscreenCollectionViewControllerDelegate <NSObject>
- (void)viewController:(MGGalleryFullscreenCollectionViewController *)viewController didUpdate:(NSMutableArray *)photoArray currentPage:(NSInteger)page onCurrentIndex:(NSIndexPath *)currentIndex;
@end

@interface MGGalleryFullscreenCollectionViewController : UICollectionViewController
@property (weak, nonatomic) id<MGGalleryFullscreenCollectionViewControllerDelegate> controllerDelegate;
@property (assign, nonatomic) NSInteger pageNumer;
@property (strong, nonatomic) NSMutableArray *photoArray;
@property (strong, nonatomic) NSIndexPath *selectedIndexPath;
@property (strong, nonatomic) MGApiClient *apiClient;
@end
