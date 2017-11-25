//
//  MGGalleryFullscreenCollectionViewController.h
//  500px-iOS
//
//  Created by Markus Gage on 2017-11-16.
//  Copyright © 2017 Mark Gage. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGViewControllerDelegate.h"

@interface MGGalleryFullscreenCollectionViewController : UICollectionViewController
@property (weak, nonatomic) id<MGViewControllerDelegate> controllerDelegate;
@property (strong, nonatomic) NSMutableArray *photoArray;
@property (strong, nonatomic) NSIndexPath *currentIndexPath;
@end
