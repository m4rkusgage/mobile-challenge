//
//  NSString+MGUtilities.h
//  500px-iOS
//
//  Created by Markus Gage on 2017-11-25.
//  Copyright © 2017 Mark Gage. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (MGUtilities)
+ (NSString *)stringByNormalizingDateString:(NSString *)dateString;
+ (NSString *)stringByTimeIntervalFromDateString:(NSString *)dateString;
@end
