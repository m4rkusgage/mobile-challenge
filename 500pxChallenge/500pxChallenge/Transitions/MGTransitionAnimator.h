//
//  MGTransitionAnimator.h
//  500px-iOS
//
//  Created by Markus Gage on 2017-11-24.
//  Copyright © 2017 Mark Gage. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MGTransitionAnimator : NSObject<UIViewControllerAnimatedTransitioning>
- (instancetype)initWithOperation:(UINavigationControllerOperation)operation;
- (instancetype)initWithOperation:(UINavigationControllerOperation)operation andDuration:(NSTimeInterval)duration;
@end
