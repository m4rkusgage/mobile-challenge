//
//  MGGalleryFullscreenCollectionViewCell.h
//  500px-iOS
//
//  Created by Markus Gage on 2017-11-16.
//  Copyright © 2017 Mark Gage. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MGGalleryFullscreenCollectionViewCell;

@protocol MGGalleryFullscreenCollectionViewCellDelegate <NSObject>
- (void)fullscreenCell:(MGGalleryFullscreenCollectionViewCell *)cell inUse:(BOOL)isActive;
@end

@interface MGGalleryFullscreenCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) id<MGGalleryFullscreenCollectionViewCellDelegate> cellDelegate;

- (void)setImage:(UIImage *)image;
@end
