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
@property (strong, nonatomic) NSString *viewedCount;
@property (strong, nonatomic) NSString *likedCount;
@property (strong, nonatomic) NSString *commentedCount;
@property (strong, nonatomic) NSString *createdAt;
@property (strong, nonatomic) NSString *photoTitle;
@property (strong, nonatomic) NSString *photoDescription;
@end

@implementation MGPhoto

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.photoTitle = ![dictionary[@"name"] isKindOfClass:[NSNull class]] ? dictionary[@"name"] : @"";
        self.photoDescription = ![dictionary[@"description"] isKindOfClass:[NSNull class]] ? dictionary[@"description"] : @"";
        self.createdAt = dictionary[@"created_at"];
        
        self.user = [[MGUser alloc] initWithDictionary:dictionary[@"user"]];
        
        CGFloat width = [(NSNumber*)dictionary[@"width"] floatValue];
        CGFloat height = [(NSNumber*)dictionary[@"height"] floatValue];
        
        self.photoURL = dictionary[@"image_url"];
        self.photoDimension = CGSizeMake(width, height);
        
        NSInteger viewCount = [(NSNumber*)dictionary[@"times_viewed"] integerValue];
        NSInteger likeCount = [(NSNumber*)dictionary[@"votes_count"] integerValue];
        NSInteger commentCount = [(NSNumber*)dictionary[@"comments_count"] integerValue];
        
        self.viewedCount = [NSString stringWithFormat:@"%ld",(long)viewCount];
        self.likedCount = [NSString stringWithFormat:@"%ld",(long)likeCount];
        self.commentedCount = [NSString stringWithFormat:@"%ld",(long)commentCount];
    }
    return self;
}

@end
