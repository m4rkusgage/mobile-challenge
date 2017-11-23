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
    self.scrollView.maximumZoomScale = 3.0;
    [self.scrollView setBouncesZoom:NO];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellWasTapped)];
    [tapGesture setNumberOfTapsRequired:1];
    
    [self setGestureRecognizers:@[tapGesture]];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    self.photoImageView.image = nil;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.photoImageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    if (scrollView.zoomScale > self.scrollView.minimumZoomScale) {
        [self.cellDelegate fullscreenCell:self inUse:YES];
    } else {
        [self.cellDelegate fullscreenCell:self inUse:NO];
    }
}

- (void)setImage:(UIImage *)image {
    self.photoImageView.image = image;
    [UIView animateWithDuration:0.5 animations:^{
        [self.photoImageView setAlpha:1];
    }];
  //  self.scrollView.contentSize = self.photoImageView.frame.size;
}

- (void)reset {
    [self.photoImageView setAlpha:0];
}

- (void)cellWasTapped {
    [self.cellDelegate fullscreenCellWasTapped:self];
}
@end