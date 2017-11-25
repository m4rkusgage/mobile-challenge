//
//  MGGalleryFullscreenCollectionViewCell.h
//  500px-iOS
//
//  Created by Markus Gage on 2017-11-16.
//  Copyright © 2017 Mark Gage. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGCellDelegate.h"

@interface MGGalleryFullscreenCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) id<MGCellDelegate> cellDelegate;

- (void)setImage:(UIImage *)image;
- (void)reset;
@end
