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

- (CGFloat)getWidth {
    return self.collectionView.bounds.size.width - (self.marginSize * 2);
}

- (CGSize)collectionViewContentSize {
    return CGSizeMake(self.width, self.contentHeight);
}

- (void)prepareLayout {
    [super prepareLayout];
    
    NSMutableArray<NSNumber *> *xOffsets = [[NSMutableArray alloc] initWithObjects:@(self.marginSize), nil];
    NSMutableArray<NSNumber *> *yOffsets = [[NSMutableArray alloc] initWithObjects:@(self.marginSize), nil];
    
    NSMutableArray<NSArray *> *allRowsOfAttributes = [[NSMutableArray alloc] init];
    NSMutableArray<UICollectionViewLayoutAttributes *> *currentRowOfAttributes = [[NSMutableArray alloc] init];
    
    for (int item = 0; item < [self.collectionView numberOfItemsInSection:0] - 1; item++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:0];
        CGSize itemSize = [self.gridDelegate collectionView:self.collectionView sizeForItemAtIndexPath:indexPath];
        
        CGRect frame = CGRectMake([xOffsets[item] floatValue], [yOffsets[item] floatValue], itemSize.width, itemSize.height);
        
        UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        attributes.frame = frame;
        
        [currentRowOfAttributes addObject:attributes];
        
        NSIndexPath *nextIndexPath = [NSIndexPath indexPathForItem:item+1 inSection:0];
        CGSize nextItemSize = [self.gridDelegate collectionView:self.collectionView sizeForItemAtIndexPath:nextIndexPath];
        
        CGFloat widthOfFrame = frame.origin.x + frame.size.width + nextItemSize.width + self.marginSize;
        if (widthOfFrame < self.width) {
            [yOffsets addObject:@(frame.origin.y)];
            
            CGFloat updatedXOffset = [xOffsets[item] floatValue] + attributes.frame.size.width + self.marginSize;
            [xOffsets addObject:@(updatedXOffset)];
        } else {
            [allRowsOfAttributes addObject:[currentRowOfAttributes copy]];
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
    self.contentHeight += 1;
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

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.attributeCache[indexPath.item];
}

- (CGFloat)preferredHeight {
    if (!_preferredHeight) {
        _preferredHeight = 100;
    }
    return _preferredHeight;
}

- (CGFloat)marginSize {
    if (!_marginSize) {
        _marginSize = 0;
    }
    return _marginSize;
}
@end
