//
//  MGConstants.h
//  500px-iOS
//
//  Created by Markus Gage on 2017-11-16.
//  Copyright © 2017 Mark Gage. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MGConstants : NSObject

extern NSString *const kMG500pxClientKey;
extern NSString *const kMG500pxClientSecret;
extern NSString *const kMG500pxCallBackURL;

extern NSString *const kMG500pxAPIBase;
extern NSString *const kMG500pxAPIRequestTokenPath;
extern NSString *const kMG500pxAPIAuthorizePath;
extern NSString *const kMG500pxAPIAccessTokenPath;

extern NSString *const kMG500pxAPIPhotosPath;

extern NSString *const kMG500pxPhotoParameterFeature;
extern NSString *const kMG500pxPhotoParameterOnly;
extern NSString *const kMG500pxPhotoParameterExclude;
extern NSString *const kMG500pxPhotoParameterSort;
extern NSString *const kMG500pxPhotoParameterSortDirection;
extern NSString *const kMG500pxPhotoParameterPage;
extern NSString *const kMG500pxPhotoParameterImageSize;
extern NSString *const kMG500pxPhotoParameterTags;

extern NSString *const kMG500pxPhotoFeaturePopular;

extern NSString *const kMG500pxPhotoCategoryNude;
extern NSString *const kMG500pxPhotoCategoryTravel;
extern NSString *const kMG500pxPhotoCategoryLandscape;

extern NSString *const kMG500pxPhotoSortCreated;
extern NSString *const kMG500pxPhotoSortRating;
extern NSString *const kMG500pxPhotoSortTaken;

extern NSString *const kMG500pxPhotoSortDirectionAsc;
extern NSString *const kMG500pxPhotoSortDirectionDesc;

extern NSString *const kMG500pxPhotoImageSize4;

@end
