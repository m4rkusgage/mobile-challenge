//
//  MGApiClient.m
//  500px-iOS
//
//  Created by Markus Gage on 2017-11-16.
//  Copyright © 2017 Mark Gage. All rights reserved.
//

#import "MGApiClient.h"
#import <OAuth/OAuth.h>

@interface MGApiClient()
@property (strong, nonatomic) OAuthClient *authClient;
@end

@implementation MGApiClient

static MGApiClient *_sharedInstance = nil;

+ (MGApiClient *)sharedInstance {
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[MGApiClient alloc] init];
    });
    
    return _sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.authClient = [OAuthClient sharedInstance];
        [self.authClient setBaseURLString:kMG500pxAPIBase
                              consumerKey:kMG500pxClientKey
                           consumerSecret:kMG500pxClientSecret];
    }
    return self;
}

- (void)setUpAPIClient:(Success)completion {
    [self.authClient authorizeUsingOAuthWithRequestTokenPath:kMG500pxAPIRequestTokenPath
                                   userAuthorizationPath:kMG500pxAPIAuthorizePath
                                         accessTokenPath:kMG500pxAPIAccessTokenPath
                                         callbackURLPath:kMG500pxCallBackURL
                                              completion:^(BOOL isSuccessful, NSError *error) {
                                                  
                                                  dispatch_sync(dispatch_get_main_queue(), ^{
                                                      completion(isSuccessful, error);
                                                  });
                                              }];
}

- (void)authorize {
    [self.authClient authorize];
}

- (void)verifyAuthorizationFromURL:(NSURL *)url completion:(Success)completion {
    [self.authClient authorizationOpenFromURL:url completion:^(BOOL isSuccessful, NSError *error) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            completion(isSuccessful, error);
        });
    }];
}

- (void)getListPhotosForFeature:(NSString *)feature includedCategories:(NSArray *)categories excludedCategories:(NSArray *)excludedCategories page:(NSInteger)page completion:(CompletionHandler)completion {
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithDictionary:@{kMG500pxPhotoParameterFeature : feature, kMG500pxPhotoParameterPage : [NSString stringWithFormat:@"%ld",(long)page]}];
    
    if ([categories count]) {
        NSString *categoriesString = [categories componentsJoinedByString:@","];
        [parameters addEntriesFromDictionary:@{kMG500pxPhotoParameterOnly : categoriesString}];
    }
    
    if ([excludedCategories count]) {
        NSString *categoriesString = [excludedCategories componentsJoinedByString:@","];
        [parameters addEntriesFromDictionary:@{kMG500pxPhotoParameterExclude : categoriesString}];
    }
    
    [parameters addEntriesFromDictionary:@{kMG500pxPhotoParameterSortDirection : kMG500pxPhotoSortDirectionDesc,
                                           kMG500pxPhotoParameterImageSize : kMG500pxPhotoImageSize4,
                                           kMG500pxPhotoParameterTags : @"1",
                                           @"rpp":@"100"
                                           }];
    
    [self.authClient authorizedRequestPath:kMG500pxAPIPhotosPath forHTTPMethod:@"GET" extraParameters:[parameters copy] completion:^(id result, NSError *error) {
        NSMutableArray *photoArray = [[NSMutableArray alloc] init];
        
        NSDictionary *responseDictionary = (NSDictionary *)result;
        
        for (NSDictionary *photoDictionary in responseDictionary[@"photos"]) {
            MGPhoto *photo = [[MGPhoto alloc] initWithDictionary:photoDictionary];
            [photoArray addObject:photo];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completion([photoArray copy], nil);
        });
    }];
}
@end
