//
//  MGTransitionAnimator.m
//  500px-iOS
//
//  Created by Markus Gage on 2017-11-24.
//  Copyright © 2017 Mark Gage. All rights reserved.
//

#import "MGTransitionAnimator.h"
#import "MGGridCollectionViewController.h"
#import "MGGalleryFullscreenCollectionViewController.h"

#define kMGTransitionDuration 0.35

@interface MGTransitionAnimator ()
@property (assign, nonatomic) UINavigationControllerOperation operationType;
@property (assign, nonatomic) NSTimeInterval transitionDuration;
@end

@implementation MGTransitionAnimator

- (instancetype)initWithOperation:(UINavigationControllerOperation)operation {
    self = [super init];
    if (self) {
        self.operationType = operation;
        self.transitionDuration = kMGTransitionDuration;
    }
    return self;
}

- (instancetype)initWithOperation:(UINavigationControllerOperation)operation andDuration:(NSTimeInterval)duration {
    self = [super init];
    if (self) {
        self.operationType = operation;
        self.transitionDuration = duration;
    }
    return self;
}

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {
    return self.transitionDuration;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *toController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIView *container = [transitionContext containerView];
    
    UIView *snapshot = [fromController.view resizableSnapshotViewFromRect:fromController.view.frame afterScreenUpdates:NO withCapInsets:UIEdgeInsetsZero];
    [container addSubview:snapshot];
    
    toController.view.alpha = 0.0f;
    [container addSubview:toController.view];
    
    [UIView animateWithDuration:self.transitionDuration animations:^{
        toController.view.alpha = 1.0f;
    } completion:^(BOOL finished){
        [fromController.view removeFromSuperview];
        [transitionContext completeTransition:finished];
    }];
}

@end
