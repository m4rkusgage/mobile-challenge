//
//  MGApiClient.h
//  500px-iOS
//
//  Created by Markus Gage on 2017-11-16.
//  Copyright © 2017 Mark Gage. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^Success)(BOOL isSuccessful, NSError *error);

@interface MGApiClient : NSObject

+ (MGApiClient *)sharedInstance;
- (void)setUpAPIClient:(Success)completion;

- (void)authorize;
- (void)verifyAuthorizationFromURL:(NSURL *)url completion:(Success)comletion;

@end
