//
//  MGTitleTableViewCell.m
//  500px-iOS
//
//  Created by Markus Gage on 2017-11-22.
//  Copyright © 2017 Mark Gage. All rights reserved.
//

#import "MGTitleTableViewCell.h"

@implementation MGTitleTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self setBackgroundColor:[UIColor clearColor]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
