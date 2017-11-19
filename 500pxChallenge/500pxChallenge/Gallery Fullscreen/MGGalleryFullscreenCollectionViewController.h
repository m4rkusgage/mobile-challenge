//
//  MGGalleryFullscreenCollectionViewController.h
//  500px-iOS
//
//  Created by Markus Gage on 2017-11-16.
//  Copyright © 2017 Mark Gage. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGApiClient.h"

@interface MGGalleryFullscreenCollectionViewController : UICollectionViewController
@property (assign, nonatomic) NSInteger pageNumer;
@property (strong, nonatomic) NSMutableArray *photoArray;
@property (strong, nonatomic) NSIndexPath *currentIndexPath;
@property (strong, nonatomic) MGApiClient *apiClient;
@end
