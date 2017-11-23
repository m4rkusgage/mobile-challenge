//
//  MGFullscreenLayout.m
//  500px-iOS
//
//  Created by Markus Gage on 2017-11-18.
//  Copyright © 2017 Mark Gage. All rights reserved.
//

#import "MGFullscreenLayout.h"

@interface MGFullscreenLayout ()
@property (assign, nonatomic) CGFloat contentWidth;
@property (strong, nonatomic) NSMutableArray<UICollectionViewLayoutAttributes *> *attributeCache;
@property (strong, nonatomic) NSMutableArray<UICollectionViewLayoutAttributes *> *supplementaryCache;
@end

@implementation MGFullscreenLayout

- (instancetype)init {
    self = [super init];
    if (self) {
        [self layoutSetup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self layoutSetup];
    }
    return self;
}

- (void)layoutSetup {
    self.contentWidth = 0;
    self.attributeCache = [[NSMutableArray alloc] init];
    self.supplementaryCache = [[NSMutableArray alloc] init];
}

- (void)clearCache {
    [self.attributeCache removeAllObjects];
    [self.supplementaryCache removeAllObjects];
}

- (CGSize)collectionViewContentSize {
    return CGSizeMake(self.contentWidth, self.collectionView.bounds.size.height);
}

- (void)prepareLayout {
    [super prepareLayout];
    [self clearCache];
    
    UICollectionViewLayoutAttributes *headerAttribute = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader withIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    [self updateHeaderAttributes:headerAttribute];
    [self.supplementaryCache addObject:headerAttribute];
    
    UICollectionViewLayoutAttributes *footerAttribute = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter withIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    [self updateFooterAttributes:footerAttribute];
    [self.supplementaryCache addObject:footerAttribute];
    
    CGFloat xOffset = 0;
    CGFloat yOffset = 0;
    
    for (int item = 0; item < [self.collectionView numberOfItemsInSection:0]; item++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:0];
        CGSize itemSize = self.collectionView.bounds.size;
        
        CGRect frame = CGRectMake(xOffset, yOffset, itemSize.width, itemSize.height);
        
        UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        attributes.frame = frame;
        
        [self.attributeCache addObject:attributes];
        
        self.contentWidth = frame.origin.x + frame.size.width;
        
        xOffset += itemSize.width;
    }
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray *layoutAttributes = [[NSMutableArray alloc] init];

    for (UICollectionViewLayoutAttributes *supplementaryAttributes in self.supplementaryCache) {
        if ([[supplementaryAttributes representedElementKind] isEqualToString:UICollectionElementKindSectionHeader]) {
            [self updateHeaderAttributes:supplementaryAttributes];
            [layoutAttributes addObject:supplementaryAttributes];
        } else {
            [self updateFooterAttributes:supplementaryAttributes];
            [layoutAttributes addObject:supplementaryAttributes];
        }
    }
    for (UICollectionViewLayoutAttributes *attributes in self.attributeCache) {
        if (CGRectIntersectsRect(attributes.frame, rect)) {
            [layoutAttributes addObject:attributes];
        }
    }
    
    return layoutAttributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.attributeCache[indexPath.item];
}

- (UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath {
    return self.attributeCache[itemIndexPath.item];
}

- (UICollectionViewLayoutAttributes *)finalLayoutAttributesForDisappearingItemAtIndexPath:(NSIndexPath *)itemIndexPath {
    return [self layoutAttributesForItemAtIndexPath:itemIndexPath];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attribute = self.supplementaryCache[indexPath.item];
    return attribute;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

- (void)updateHeaderAttributes:(UICollectionViewLayoutAttributes *)attribute {
    attribute.frame = CGRectMake(self.collectionView.contentOffset.x, 0, CGRectGetWidth(self.collectionView.bounds), 70);
    attribute.alpha = [self.fullscreenDelegate collectionViewCurrentAlpha:self.collectionView];
    attribute.zIndex = 1;
}

- (void)updateFooterAttributes:(UICollectionViewLayoutAttributes *)attribute {
    CGSize footerSize = [self.fullscreenDelegate collectionViewSizeOfFooterView:self.collectionView];
    
    attribute.frame = CGRectMake(self.collectionView.contentOffset.x, CGRectGetHeight(self.collectionView.bounds) - footerSize.height, CGRectGetWidth(self.collectionView.bounds), footerSize.height);
     attribute.alpha = [self.fullscreenDelegate collectionViewCurrentAlpha:self.collectionView];
    attribute.zIndex = 1;
}
@end
