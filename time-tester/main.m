//
//  main.m
//  time-tester
//
//  Created by saifuddin on 12/11/13.
//  Copyright (c) 2013 saifuddin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSDate+CuppaDateChecker.h"

int main(int argc, const char * argv[])
{
    // We're using now as reference
    NSDate *buyingDate = [NSDate date];

    // Example opening hours that we might be extracted from a cafe's opening hours
    // We convert it to NSDictionary
    // The structure is as follows:
    // 1. Must always have 7 key/value pair with keys monday, tuesday, wednesday, thursday, friday, saturday, sunday
    // 2. Values for each key is called time blocks. Time blocks are defined as follows:
    // - Each time blocks contains start time and end time.
    // - Each start/end time is in the format 'HH:mm-HH:mm' (startTime-endTime)
    // - time blocks are separated by the bar '|' character
    // - e.g. startTime-endTime|startTime-endTime
    NSString *jsonString = @"{\"monday\":\"09:00-12:00\",\"tuesday\":\"09:00-12:00\",\"wednesday\":"",\"thursday\":\"09:00-12:00|14:00-18:00\",\"friday\":\"09:00-12:00\",\"saturday\":"",\"sunday\":\"09:00-12:00\"}";
    NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dictOpeningHours = [NSJSONSerialization JSONObjectWithData:data
                                                         options:NSJSONReadingMutableContainers
                                                           error:nil];

    // We chec whether our buyingDate is within the opening hours or not
    BOOL buyingDateWithinOpeningHours = [NSDate date:buyingDate withinOpeningHoursDefinition:dictOpeningHours];
    NSLog(@"Buying date within opening hours? %@",buyingDateWithinOpeningHours ? @"YES" : @"NO");
    return 0;
}

