//
//  MGLayoutDelegate.h
//  500px-iOS
//
//  Created by Markus Gage on 2017-11-24.
//  Copyright © 2017 Mark Gage. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MGLayoutDelegate <NSObject>
- (CGSize)collectionView:(UICollectionView *)collectionView sizeForItemAtIndexPath:(NSIndexPath *)indexPath;

@optional
- (CGSize)collectionView:(UICollectionView *)collectionView sizeForSupplementaryElementKind:(NSString *)kind AtIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)collectionView:(UICollectionView *)collectionView alphaForItemAtIndexPath:(NSIndexPath *)indexPath;
@end
