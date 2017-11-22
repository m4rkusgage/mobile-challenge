//
//  MGPhoto.h
//  500px-iOS
//
//  Created by Markus Gage on 2017-11-16.
//  Copyright © 2017 Mark Gage. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ModelProtocol.h"
#import "MGUser.h"

@interface MGPhoto : NSObject<ModelProtocol>
@property (assign, nonatomic) BOOL wasShown;
@property (assign, nonatomic, readonly) CGSize photoDimension;
@property (strong, nonatomic, readonly) NSString *photoURL;
@property (strong, nonatomic, readonly) NSString *viewedCount;
@property (strong, nonatomic, readonly) NSString *likedCount;
@property (strong, nonatomic, readonly) NSString *commentedCount;
@property (strong, nonatomic, readonly) NSString *createdAt;
@property (strong, nonatomic, readonly) NSString *photoTitle;
@property (strong, nonatomic, readonly) NSString *photoDescription;
@property (strong, nonatomic) UIImage *photoImage;
@property (strong, nonatomic) MGUser *user;
@end
