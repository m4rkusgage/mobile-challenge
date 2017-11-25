//
//  MGFooterCollectionReusableView.h
//  500px-iOS
//
//  Created by Markus Gage on 2017-11-20.
//  Copyright © 2017 Mark Gage. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGReusableViewDelegate.h"

@interface MGFooterCollectionReusableView : UICollectionReusableView
@property (weak, nonatomic) id<MGReusableViewDelegate> reusableViewDelegate;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *createdAtLabel;
@property (weak, nonatomic) IBOutlet UILabel *viewedCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *likeCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorNameLabel;
@end
