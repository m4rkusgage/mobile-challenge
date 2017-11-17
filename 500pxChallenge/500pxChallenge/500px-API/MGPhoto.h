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

@interface MGPhoto : NSObject<ModelProtocol>
@property (assign, nonatomic, readonly) CGSize photoDimension;
@property (strong, nonatomic, readonly) NSString *photoURL;
@property (strong, nonatomic) UIImage *photoImage;
@end
