//
//  MGPhoto.m
//  500px-iOS
//
//  Created by Markus Gage on 2017-11-16.
//  Copyright © 2017 Mark Gage. All rights reserved.
//

#import "MGPhoto.h"

@interface MGPhoto ()
@property (assign, nonatomic) CGSize photoDimension;
@property (strong, nonatomic) NSString *photoURL;
@property (strong, nonatomic) UIImage *photoImage;
@end

@implementation MGPhoto

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        CGFloat width = [(NSNumber*)dictionary[@"width"] floatValue];
        CGFloat height = [(NSNumber*)dictionary[@"height"] floatValue];
        
        self.photoURL = dictionary[@"image_url"];
        self.photoDimension = CGSizeMake(width, height);
    }
    return self;
}
@end
