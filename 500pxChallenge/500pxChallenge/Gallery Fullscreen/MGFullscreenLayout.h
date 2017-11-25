//
//  MGFullscreenLayout.h
//  500px-iOS
//
//  Created by Markus Gage on 2017-11-18.
//  Copyright © 2017 Mark Gage. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGLayoutDelegate.h"

@interface MGFullscreenLayout : UICollectionViewLayout
@property (weak, nonatomic) IBOutlet id<MGLayoutDelegate> layoutDelegate;
@end
