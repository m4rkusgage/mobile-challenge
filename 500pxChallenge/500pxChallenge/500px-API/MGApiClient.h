//
//  MGApiClient.h
//  500px-iOS
//
//  Created by Markus Gage on 2017-11-16.
//  Copyright © 2017 Mark Gage. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MGConstants.h"
#import "MGPhoto.h"

typedef void(^Success)(BOOL isSuccessful, NSError *error);
typedef void(^CompletionHandler)(NSArray *result, NSError *error);

@interface MGApiClient : NSObject

+ (MGApiClient *)sharedInstance;
- (void)setUpAPIClient:(Success)completion;

- (void)authorize;
- (void)verifyAuthorizationFromURL:(NSURL *)url completion:(Success)completion;

- (void)getListPhotosForFeature:(NSString *)feature
             includedCategories:(NSArray *)categories
             excludedCategories:(NSArray *)excludedCategories
                           page:(NSInteger)page
                     completion:(CompletionHandler)completion;
@end
