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
    
    [self.scrollView setDelegate:self];
    self.scrollView.minimumZoomScale = 1.0;
    self.scrollView.maximumZoomScale = 3.0;
    [self.scrollView setBouncesZoom:YES];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellWasSelected)];
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
    BOOL isInteractedWith = (scrollView.zoomScale > self.scrollView.minimumZoomScale) ? YES : NO;
    [self.cellDelegate collectionViewCell:self isInteractedWith:isInteractedWith];
}

- (void)setImage:(UIImage *)image {
    self.photoImageView.image = image;
    [UIView animateWithDuration:0.35 animations:^{
        [self.photoImageView setAlpha:1];
    }];
}

- (void)reset {
    [self.photoImageView setAlpha:0];
}

- (void)cellWasSelected {
    [self setSelected:!self.selected];
    [self.cellDelegate collectionViewCell:self isSelected:self.selected];
}
@end
