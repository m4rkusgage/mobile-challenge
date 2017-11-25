//
//  MGGridLayout.m
//  500px-iOS
//
//  Created by Markus Gage on 2017-11-16.
//  Copyright © 2017 Mark Gage. All rights reserved.
//

#import "MGGridLayout.h"

@interface MGGridLayout ()
@property (assign, nonatomic) CGFloat contentHeight;
@property (assign, nonatomic, getter=getWidth) CGFloat width;
@property (strong, nonatomic) NSMutableArray<UICollectionViewLayoutAttributes *> *attributeCache;
@property (strong, nonatomic) NSMutableArray<UICollectionViewLayoutAttributes *> *previousAttributeCache;
@end

@implementation MGGridLayout

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
    self.contentHeight = 0;
    self.attributeCache = [[NSMutableArray alloc] init];
}

#pragma mark - Getter Methods
- (CGFloat)getWidth {
    return CGRectGetWidth(self.collectionView.bounds) - (self.marginSize * 2);
}

- (CGFloat)marginSize {
    if (!_marginSize) {
        _marginSize = 0;
    }
    return _marginSize;
}

- (CGFloat)preferredHeight {
    if (!_preferredHeight) {
        _preferredHeight = 100;
    }
    return _preferredHeight;
}

#pragma mark - UICollectionViewLayout Methods
- (CGSize)collectionViewContentSize {
    return CGSizeMake(self.width, self.contentHeight);
}

- (void)prepareLayout {
    [super prepareLayout];
    
    self.previousAttributeCache = [self.attributeCache mutableCopy];
    [self.attributeCache removeAllObjects];
    
    NSMutableArray<NSNumber *> *xOffsets = [[NSMutableArray alloc] initWithObjects:@(self.marginSize), nil];
    NSMutableArray<NSNumber *> *yOffsets = [[NSMutableArray alloc] initWithObjects:@(self.marginSize), nil];
    
    NSMutableArray<NSArray *> *allRowsOfAttributes = [[NSMutableArray alloc] init];
    NSMutableArray<UICollectionViewLayoutAttributes *> *currentRowOfAttributes = [[NSMutableArray alloc] init];
    
    for (int item = 0; item < [self.collectionView numberOfItemsInSection:0] - 1; item++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:0];
        CGSize itemSize = [self.layoutDelegate collectionView:self.collectionView sizeForItemAtIndexPath:indexPath];
        
        CGRect frame = CGRectMake([xOffsets[item] floatValue], [yOffsets[item] floatValue], itemSize.width, itemSize.height);
        
        UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        attributes.frame = frame;
        
        [currentRowOfAttributes addObject:attributes];
        
        NSIndexPath *nextIndexPath = [NSIndexPath indexPathForItem:item+1 inSection:0];
        CGSize nextItemSize = [self.layoutDelegate collectionView:self.collectionView sizeForItemAtIndexPath:nextIndexPath];
        
        CGFloat widthOfFrame = frame.origin.x + frame.size.width + nextItemSize.width + self.marginSize;
        if (widthOfFrame < self.width) {
            [yOffsets addObject:@(frame.origin.y)];
            
            CGFloat updatedXOffset = [xOffsets[item] floatValue] + attributes.frame.size.width + self.marginSize;
            [xOffsets addObject:@(updatedXOffset)];
        } else {
            NSArray *updatedRowOfAttributes = [self updateRowAttribues:currentRowOfAttributes];
            
            [allRowsOfAttributes addObject:updatedRowOfAttributes];
            [xOffsets addObject:@(self.marginSize)];
            
            CGFloat updatedYOffset = [yOffsets[item] floatValue] + attributes.frame.size.height + self.marginSize;
            [yOffsets addObject:@(updatedYOffset)];
            
            [currentRowOfAttributes removeAllObjects];
        }
    }
    for (NSArray *row in allRowsOfAttributes) {
        for (UICollectionViewLayoutAttributes *attributes in row) {
            [self.attributeCache addObject:attributes];
            self.contentHeight = MAX(self.contentHeight, CGRectGetMaxY(attributes.frame));
        }
    }
    self.contentHeight += self.marginSize;
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray *layoutAttributes = [[NSMutableArray alloc] init];
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

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    CGRect oldBounds = self.collectionView.bounds;
    if (CGRectGetWidth(oldBounds) != CGRectGetWidth(newBounds)) {
        return YES;
    }
    return NO;
}

#pragma mark - Helper Methods
- (NSArray *)updateRowAttribues:(NSArray *)attributesArray {
    CGFloat rowWidth = [self getWidthOfRow:attributesArray];
    CGFloat ratio = rowWidth / self.width;
    CGFloat xOffset = self.marginSize;
    
    for (UICollectionViewLayoutAttributes *attributes in attributesArray) {
        CGRect frame = attributes.frame;
        frame.origin.x = xOffset;
        frame.size.width /= ratio;
        frame.size.height /= ratio;
        
        attributes.frame = frame;
        xOffset = frame.origin.x + frame.size.width + self.marginSize;
    }
    return [attributesArray copy];
}

- (CGFloat)getWidthOfRow:(NSArray *)rowOfAttributes {
    CGFloat widthTotal = (self.marginSize * ([rowOfAttributes count] - 1));
    for (UICollectionViewLayoutAttributes *attributes in rowOfAttributes) {
        widthTotal += (attributes.frame.size.width);
    }
    return widthTotal;
}



@end
