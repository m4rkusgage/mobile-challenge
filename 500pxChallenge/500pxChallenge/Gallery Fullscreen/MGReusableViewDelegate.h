//
//  MGReusableViewDelegate.h
//  500px-iOS
//
//  Created by Markus Gage on 2017-11-20.
//  Copyright © 2017 Mark Gage. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MGReusableViewDelegate <NSObject>
- (void)reusableViewDidClose:(UICollectionReusableView *)reusableView;
@end
