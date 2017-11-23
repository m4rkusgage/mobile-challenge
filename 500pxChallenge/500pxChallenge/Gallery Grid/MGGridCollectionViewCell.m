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
    // Initialization code
    self.backgroundColor = [UIColor colorWithHue:1.0 saturation:0.0 brightness:0.13 alpha:1];
    
    [self reset];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    self.photoImageView.image = nil;
}

- (void)reset {
    [self.photoImageView setAlpha:0];
    self.photoImageView.image = nil;
}

- (void)setImage:(UIImage *)image {
    self.photoImageView.image = image;
    [UIView animateWithDuration:0.5 animations:^{
        [self.photoImageView setAlpha:1];
    }];
}

@end
