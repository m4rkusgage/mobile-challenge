//
//  MGHeaderCollectionReusableView.h
//  500px-iOS
//
//  Created by Markus Gage on 2017-11-19.
//  Copyright © 2017 Mark Gage. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGReusableViewDelegate.h"

@interface MGHeaderCollectionReusableView : UICollectionReusableView
@property (weak, nonatomic) id<MGReusableViewDelegate> reusableViewDelegate;
@end
