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
@property (strong, nonatomic) NSMutableArray<UICollectionViewLayoutAttributes *> *previousAttributeCache;
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
    return CGSizeMake(self.contentWidth, CGRectGetHeight(self.collectionView.bounds));
}

- (void)prepareLayout {
    [super prepareLayout];
    self.previousAttributeCache = [self.attributeCache mutableCopy];
    [self clearCache];
    
    NSIndexPath *supplementaryViewIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    UICollectionViewLayoutAttributes *headerAttribute = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader withIndexPath:supplementaryViewIndexPath];
    [self updateHeaderAttributes:headerAttribute atIndexPath:supplementaryViewIndexPath];
    [self.supplementaryCache addObject:headerAttribute];
    
    UICollectionViewLayoutAttributes *footerAttribute = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter withIndexPath:supplementaryViewIndexPath];
    [self updateFooterAttributes:footerAttribute atIndexPath:supplementaryViewIndexPath];
    [self.supplementaryCache addObject:footerAttribute];
    
    CGFloat xOffset = 0;
    CGFloat yOffset = 0;
    
    for (int item = 0; item < [self.collectionView numberOfItemsInSection:0]; item++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:0];
        CGSize itemSize = [self.layoutDelegate collectionView:self.collectionView sizeForItemAtIndexPath:indexPath];
        
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
    NSIndexPath *supplementaryViewIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    for (UICollectionViewLayoutAttributes *supplementaryAttributes in self.supplementaryCache) {
        if ([[supplementaryAttributes representedElementKind] isEqualToString:UICollectionElementKindSectionHeader]) {
            [self updateHeaderAttributes:supplementaryAttributes atIndexPath:supplementaryViewIndexPath];
            [layoutAttributes addObject:supplementaryAttributes];
        } else {
            [self updateFooterAttributes:supplementaryAttributes atIndexPath:supplementaryViewIndexPath];
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

- (UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath {
    return self.previousAttributeCache[itemIndexPath.item];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.attributeCache[indexPath.item];
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

- (void)updateHeaderAttributes:(UICollectionViewLayoutAttributes *)attribute atIndexPath:(NSIndexPath *)indexPath {
    CGSize headerSize = [self.layoutDelegate collectionView:self.collectionView sizeForSupplementaryElementKind:UICollectionElementKindSectionHeader AtIndexPath:indexPath];
    attribute.frame = CGRectMake(self.collectionView.contentOffset.x, 0, headerSize.width, headerSize.height);
    attribute.alpha = [self.layoutDelegate collectionView:self.collectionView alphaForItemAtIndexPath:indexPath];
    attribute.zIndex = 1;
}

- (void)updateFooterAttributes:(UICollectionViewLayoutAttributes *)attribute atIndexPath:(NSIndexPath *)indexPath {
    CGSize footerSize = [self.layoutDelegate collectionView:self.collectionView sizeForSupplementaryElementKind:UICollectionElementKindSectionFooter AtIndexPath:indexPath];
    attribute.frame = CGRectMake(self.collectionView.contentOffset.x, CGRectGetHeight(self.collectionView.bounds) - footerSize.height, footerSize.width, footerSize.height);
    attribute.alpha = [self.layoutDelegate collectionView:self.collectionView alphaForItemAtIndexPath:indexPath];
    attribute.zIndex = 1;
}
@end
