//
//  MGGridLayout.h
//  500px-iOS
//
//  Created by Markus Gage on 2017-11-16.
//  Copyright © 2017 Mark Gage. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGLayoutDelegate.h"

@interface MGGridLayout : UICollectionViewLayout
@property (weak, nonatomic) IBOutlet id<MGLayoutDelegate> layoutDelegate;
@property (assign, nonatomic) IBInspectable CGFloat preferredHeight;
@property (assign, nonatomic) IBInspectable CGFloat marginSize;
@end
