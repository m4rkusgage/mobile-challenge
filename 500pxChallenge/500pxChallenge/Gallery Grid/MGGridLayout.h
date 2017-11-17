//
//  MGGridLayout.h
//  500px-iOS
//
//  Created by Markus Gage on 2017-11-16.
//  Copyright © 2017 Mark Gage. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MGGridLayoutDelegate <NSObject>
- (CGSize)collectionView:(UICollectionView *)collectionView sizeForItemAtIndexPath:(NSIndexPath *)indexPath;
@end

@interface MGGridLayout : UICollectionViewLayout
@property (weak, nonatomic) IBOutlet id<MGGridLayoutDelegate> gridDelegate;
@property (assign, nonatomic) IBInspectable CGFloat preferredHeight;
@property (assign, nonatomic) IBInspectable CGFloat marginSize;
@end
