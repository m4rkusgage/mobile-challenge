//
//  MGGalleryFullscreenCollectionViewCell.m
//  500px-iOS
//
//  Created by Markus Gage on 2017-11-16.
//  Copyright © 2017 Mark Gage. All rights reserved.
//

#import "MGGalleryFullscreenCollectionViewCell.h"

@interface MGGalleryFullscreenCollectionViewCell ()<UIScrollViewDelegate>
@end

@implementation MGGalleryFullscreenCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.scrollView setDelegate:self];
    self.scrollView.minimumZoomScale = 1.0;
    self.scrollView.maximumZoomScale = 6.0;
    [self.scrollView setBouncesZoom:YES];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.photoImageView;
}

- (void)setImage:(UIImage *)image {
    self.photoImageView.image = image;
}

@end
