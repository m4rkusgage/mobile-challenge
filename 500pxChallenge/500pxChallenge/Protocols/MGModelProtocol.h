//
//  MGModelProtocol.h
//  500px-iOS
//
//  Created by Markus Gage on 2017-11-25.
//  Copyright © 2017 Mark Gage. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MGModelProtocol <NSObject>
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end
