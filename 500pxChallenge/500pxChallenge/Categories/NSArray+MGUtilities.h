//
//  NSArray+MGUtilities.h
//  500px-iOS
//
//  Created by Markus Gage on 2017-11-25.
//  Copyright © 2017 Mark Gage. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (MGUtilities)
- (NSArray *)sortedArrayByKey:(NSString *)key ascending:(BOOL)ascending;
@end
