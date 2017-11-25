//
//  MGGridCollectionViewCell.m
//  500px-iOS
//
//  Created by Markus Gage on 2017-11-16.
//  Copyright © 2017 Mark Gage. All rights reserved.
//

#import "MGGridCollectionViewCell.h"

@implementation MGGridCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor colorWithHue:1.0 saturation:0.0 brightness:0.13 alpha:1];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.photoImageView.image = nil;
}

- (void)reset {
    [self.photoImageView setAlpha:0];
}

- (void)setImage:(UIImage *)image {
    self.photoImageView.image = image;
    [UIView animateWithDuration:0.35 animations:^{
        [self.photoImageView setAlpha:1];
    }];
}

@end
