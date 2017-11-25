//
//  MGUser.m
//  500px-iOS
//
//  Created by Markus Gage on 2017-11-22.
//  Copyright © 2017 Mark Gage. All rights reserved.
//

#import "MGUser.h"

@interface MGUser ()
@property (strong, nonatomic) NSString *userFullName;
@property (strong, nonatomic) NSString *userAvatarURL;
@end

@implementation MGUser

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.userFullName = dictionary[@"fullname"];
        self.userAvatarURL = dictionary[@"avatars"][@"default"];
    }
    return self;
}

@end
