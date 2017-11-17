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
    return self.collectionView.bounds.size.width;
}

- (CGSize)collectionViewContentSize {
    return CGSizeMake(self.width, self.contentHeight);
}

- (void)prepareLayout {
    [super prepareLayout];
    
    NSMutableArray<NSNumber *> *xOffsets = [[NSMutableArray alloc] initWithObjects:@0, nil];
    NSMutableArray<NSNumber *> *yOffsets = [[NSMutableArray alloc] initWithObjects:@0, nil];
    
    for (int item = 0; item < [self.collectionView numberOfItemsInSection:0]; item++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:0];
        CGSize itemSize = [self.gridDelegate collectionView:self.collectionView sizeForItemAtIndexPath:indexPath];
        
        CGRect frame = CGRectMake([xOffsets[item] floatValue], [yOffsets[item] floatValue], itemSize.width, itemSize.height);
        
        UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        attributes.frame = frame;
        
        [self.attributeCache addObject:attributes];
        self.contentHeight = MAX(self.contentHeight, CGRectGetMaxY(attributes.frame));
        
        [xOffsets addObject:@0];
        CGFloat yOffset = attributes.frame.origin.y + attributes.frame.size.height;
        [yOffsets addObject:@(yOffset)];
    }
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
@end
