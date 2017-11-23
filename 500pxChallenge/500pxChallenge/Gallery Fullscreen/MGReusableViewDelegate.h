//
//  MGReusableViewDelegate.h
//  500px-iOS
//
//  Created by Markus Gage on 2017-11-20.
//  Copyright © 2017 Mark Gage. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MGPhoto.h"

typedef enum : NSUInteger {
    ReusableViewButtonShare,
    ReusableViewButtonInfo,
    ReusableViewButtonLike,
    ReusableViewButtonClose
} ReusableViewButton;

@protocol MGReusableViewDelegate <NSObject>
- (void)reusableView:(UICollectionReusableView *)reusableView buttonPressed:(ReusableViewButton)buttonType;
@end
