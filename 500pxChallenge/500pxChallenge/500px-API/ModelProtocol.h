//
//  ModelProtocol.h
//  500px-iOS
//
//  Created by Markus Gage on 2017-11-16.
//  Copyright © 2017 Mark Gage. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ModelProtocol <NSObject>
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end
