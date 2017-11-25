//
//  MGTransitionAnimator.h
//  500px-iOS
//
//  Created by Markus Gage on 2017-11-24.
//  Copyright © 2017 Mark Gage. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol TransitionDelegate <NSObject>
- (UICollectionViewCell *)transitionAnimatorSourceCell:(id<UIViewControllerAnimatedTransitioning>)animator;
- (UICollectionView *)transitionAnimatorCollectionView:(id<UIViewControllerAnimatedTransitioning>)animator;
- (UIView *)transitionAnimatorDestinationView:(id<UIViewControllerAnimatedTransitioning>)animator;
@end

@interface MGTransitionAnimator : NSObject<UIViewControllerAnimatedTransitioning>
@property (weak, nonatomic) id<TransitionDelegate> transitionDelegate;
- (instancetype)initWithOperation:(UINavigationControllerOperation)operation;
- (instancetype)initWithOperation:(UINavigationControllerOperation)operation andDuration:(NSTimeInterval)duration;
@end
