//
//  MGUser.h
//  500px-iOS
//
//  Created by Markus Gage on 2017-11-22.
//  Copyright © 2017 Mark Gage. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ModelProtocol.h"

@interface MGUser : NSObject<ModelProtocol>
@property (strong, nonatomic, readonly) NSString *userFullName;
@property (strong, nonatomic, readonly) NSString *userAvatarURL;
@property (strong, nonatomic) UIImage *userAvatar;
@end
