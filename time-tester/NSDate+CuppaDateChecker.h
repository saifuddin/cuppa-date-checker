//
//  NSDate+CuppaDateChecker.h
//  time-tester
//
//  Created by saifuddin on 13/11/13.
//  Copyright (c) 2013 saifuddin. All rights reserved.
//

#import <Foundation/Foundation.h>

enum {
    kStartTimeIndex = 0,
    kEndTimeIndex = 1,
    kHourIndex = 0,
    kMinuteIndex = 1

};

@interface NSDate (CuppaDateChecker)
+ (BOOL)date:(NSDate *)date withinOpeningHoursDefinition:(NSDictionary *)openingHoursDict;
@end
