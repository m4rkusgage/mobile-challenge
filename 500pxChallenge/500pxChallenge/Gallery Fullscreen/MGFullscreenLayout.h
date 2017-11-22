//
//  MGFullscreenLayout.h
//  500px-iOS
//
//  Created by Markus Gage on 2017-11-18.
//  Copyright © 2017 Mark Gage. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MGFullscreenLayoutDelegate <NSObject>
- (CGFloat)collectionViewCurrentAlpha:(UICollectionView *)collectionView;
- (CGSize)collectionViewSizeOfFooterView:(UICollectionView *)collectionView;
@end

@interface MGFullscreenLayout : UICollectionViewLayout
@property (weak, nonatomic) IBOutlet id<MGFullscreenLayoutDelegate> fullscreenDelegate;
@end
