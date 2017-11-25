//
//  MGFooterCollectionReusableView.m
//  500px-iOS
//
//  Created by Markus Gage on 2017-11-20.
//  Copyright © 2017 Mark Gage. All rights reserved.
//

#import "MGFooterCollectionReusableView.h"

@interface MGFooterCollectionReusableView ()
@property (strong, nonatomic) CAGradientLayer *gradientLayer;
@end

@implementation MGFooterCollectionReusableView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    UIColor *topColor = [UIColor colorWithHue:1.0 saturation:0 brightness:0 alpha:0.0];
    UIColor *bottomColor = [UIColor colorWithHue:1.0 saturation:0 brightness:0 alpha:0.85];
    
    self.gradientLayer = [CAGradientLayer layer];
    self.gradientLayer.startPoint = CGPointMake(0.5, 0);
    self.gradientLayer.endPoint = CGPointMake(0.5, 1);
    self.gradientLayer.colors = [NSArray arrayWithObjects: (id)topColor.CGColor, (id)bottomColor.CGColor, nil];
    
    [self.layer insertSublayer:self.gradientLayer atIndex:0];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.gradientLayer.frame = self.bounds;
}

- (IBAction)moreInformationButtonPressed:(id)sender {
    [self.reusableViewDelegate reusableView:self buttonPressed:ReusableViewButtonInfo];
}

@end
