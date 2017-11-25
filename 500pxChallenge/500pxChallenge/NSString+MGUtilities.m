//
//  NSString+MGUtilities.m
//  500px-iOS
//
//  Created by Markus Gage on 2017-11-25.
//  Copyright © 2017 Mark Gage. All rights reserved.
//

#import "NSString+MGUtilities.h"

@implementation NSString (MGUtilities)

+ (NSString *)stringByNormalizingDateString:(NSString *)dateString {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [dateFormatter setLocale:usLocale];
    [dateFormatter setDateFormat: @"yyyy-MM-dd'T'HH:mm:ssZ"];
    NSDate *dates = [dateFormatter dateFromString:dateString];
    
    [dateFormatter setDateFormat:@"MMM d, yyyy"];
    NSString *newDate = [dateFormatter stringFromDate:dates];
    return newDate;
}

+ (NSString *)stringByTimeIntervalFromDateString:(NSString *)dateString {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [dateFormatter setLocale:usLocale];
    [dateFormatter setDateStyle:NSDateFormatterLongStyle];
    [dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
    [dateFormatter setDateFormat: @"yyyy-MM-dd'T'HH:mm:ssZ"];
    
    NSDate *date = [dateFormatter dateFromString:dateString];
    NSDate *now = [NSDate date];
    
    NSTimeInterval seconds = [now timeIntervalSinceDate:date];
    
    if(seconds < 60) {
        return [[NSString alloc] initWithFormat:@"%.0f seconds ago", seconds];
    }
    else if(seconds < 3600) {
        return [[NSString alloc] initWithFormat:@"%.0f minutes ago", seconds/60];
    }
    else if(seconds < 3600 * 24) {
        return [[NSString alloc] initWithFormat:@"%.0f hours ago", seconds/3600];
    }
    else if(seconds < 3600 * 24 * 365) {
        return [[NSString alloc] initWithFormat:@"%.0f days ago", seconds/3600/24];
    }
    else {
        return [[NSString alloc] initWithFormat:@"%.0f years ago", seconds/3600/24/365];
    }
}
@end
