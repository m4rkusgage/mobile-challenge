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
}

- (CGSize)collectionViewContentSize {
    return CGSizeMake(self.contentWidth, self.collectionView.bounds.size.height);
}

- (void)prepareLayout {
    [super prepareLayout];
    
    UICollectionViewLayoutAttributes *headerAttribute = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    self.attributeCache[0] = headerAttribute;
    
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
    for (UICollectionViewLayoutAttributes *attributes in self.attributeCache) {
        if ([[attributes representedElementKind] isEqualToString:UICollectionElementKindSectionHeader]) {
            [self updateHeaderAttributes:attributes];
            [layoutAttributes addObject:attributes];
        } else if (CGRectIntersectsRect(attributes.frame, rect)) {
            [layoutAttributes addObject:attributes];
        }
    }
    return layoutAttributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.attributeCache[indexPath.item];
}

- (UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath
{
    return self.attributeCache[itemIndexPath.item];
}

- (UICollectionViewLayoutAttributes *)finalLayoutAttributesForDisappearingItemAtIndexPath:(NSIndexPath *)itemIndexPath
{
    return [self layoutAttributesForItemAtIndexPath:itemIndexPath];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewLayoutAttributes *attribute = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader withIndexPath:indexPath];
    
    if ([elementKind isEqualToString:UICollectionElementKindSectionHeader]) {
        [self updateHeaderAttributes:attribute];
    }
    
   
    return attribute;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    CGRect oldBounds = self.collectionView.bounds;
    if (CGRectGetWidth(oldBounds) != CGRectGetWidth(newBounds)) {
        [self.attributeCache removeAllObjects];
        return YES;
    }
    return NO;
}

- (void)updateHeaderAttributes:(UICollectionViewLayoutAttributes *)attribute {
    attribute.frame = CGRectMake(self.collectionView.frame.origin.x + self.collectionView.contentOffset.x, 0, CGRectGetWidth(self.collectionView.bounds), 50);
    attribute.zIndex = 1;
}
@end
