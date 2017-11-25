//
//  MGConstants.m
//  500px-iOS
//
//  Created by Markus Gage on 2017-11-16.
//  Copyright © 2017 Mark Gage. All rights reserved.
//

#import "MGConstants.h"

@implementation MGConstants

NSString *const kMG500pxClientKey = @"kGTi5iNcUvzUg7OvAadS11BvYOnAOmw9cX7iyuMC";
NSString *const kMG500pxClientSecret = @"xix4PYGx2vvGuIUzLh33vdt7qbfmNtqZ1F0EdDBr";
NSString *const kMG500pxCallBackURL = @"com.mark.500px://";

NSString *const kMG500pxAPIBase = @"https://api.500px.com/v1";
NSString *const kMG500pxAPIRequestTokenPath = @"/oauth/request_token";
NSString *const kMG500pxAPIAuthorizePath = @"/oauth/authorize";
NSString *const kMG500pxAPIAccessTokenPath = @"/oauth/access_token";

NSString *const kMG500pxAPIPhotosPath = @"/photos";

NSString *const kMG500pxPhotoParameterFeature = @"feature";
NSString *const kMG500pxPhotoParameterOnly = @"only";
NSString *const kMG500pxPhotoParameterExclude = @"exclude";
NSString *const kMG500pxPhotoParameterSort = @"sort";
NSString *const kMG500pxPhotoParameterSortDirection = @"sort_direction";
NSString *const kMG500pxPhotoParameterPage = @"page";
NSString *const kMG500pxPhotoParameterImageSize = @"image_size";
NSString *const kMG500pxPhotoParameterTags = @"tags";

NSString *const kMG500pxPhotoFeaturePopular = @"popular";

NSString *const kMG500pxPhotoCategoryNude = @"Nude";
NSString *const kMG500pxPhotoCategoryTravel = @"Travel";
NSString *const kMG500pxPhotoCategoryLandscape = @"Landscape";

NSString *const kMG500pxPhotoSortCreated = @"created_at";
NSString *const kMG500pxPhotoSortRating = @"rating";
NSString *const kMG500pxPhotoSortTaken = @"taken_at";
NSString *const kMG500pxPhotoSortTimesViewed = @"times_viewed";

NSString *const kMG500pxPhotoSortDirectionAsc = @"asc";
NSString *const kMG500pxPhotoSortDirectionDesc = @"desc";

NSString *const kMG500pxPhotoImageSize4 = @"4";

@end
