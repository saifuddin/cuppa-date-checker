//
//  NSDate+CuppaDateChecker.m
//  time-tester
//
//  Created by saifuddin on 13/11/13.
//  Copyright (c) 2013 saifuddin. All rights reserved.
//

#import "NSDate+CuppaDateChecker.h"

@implementation NSDate (CuppaDateChecker)


+ (BOOL)date:(NSDate *)referenceDate withinOpeningHoursDefinition:(NSDictionary *)openingHoursDict
{
    BOOL withinOpeningHoursDefinition = NO;

    NSString *weekdayString = [referenceDate descriptionWithCalendarFormat:@"%A"
                                                                  timeZone:[NSTimeZone localTimeZone]
                                                                    locale:[[NSUserDefaults standardUserDefaults] dictionaryRepresentation]];

    NSDateComponents *referenceDateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitDay|NSCalendarUnitMonth|NSCalendarUnitYear|NSCalendarUnitTimeZone
                                                                                fromDate:referenceDate];

    NSString *valStrTimeBlocks = openingHoursDict[[weekdayString lowercaseString]];
    NSArray *timeSlotsWithStrings = [valStrTimeBlocks componentsSeparatedByString:@"|"];

    for (NSString *timeSlot in timeSlotsWithStrings)
    {
        NSArray *timeSlotComponents = [timeSlot componentsSeparatedByString:@"-"];
        NSString *startTime = timeSlotComponents[kStartTimeIndex];
        NSString *endTime = timeSlotComponents[kEndTimeIndex];

        NSCalendar *calendar = [NSCalendar currentCalendar];
        [calendar setTimeZone: [NSTimeZone systemTimeZone]];

        // Start Date
        NSDateComponents *startDateComps = [NSDateComponents new];
        startDateComps.hour = [[startTime componentsSeparatedByString:@":"][kHourIndex] integerValue];
        startDateComps.minute = [[startTime componentsSeparatedByString:@":"][kMinuteIndex] integerValue];
        startDateComps.second = 0;
        startDateComps.year = referenceDateComponents.year;
        startDateComps.month = referenceDateComponents.month;
        startDateComps.day = referenceDateComponents.day;
        startDateComps.timeZone = [NSTimeZone systemTimeZone];
        NSDate *startDate = [calendar dateFromComponents:startDateComps];

        // End Date
        NSDateComponents *endDateComps = [NSDateComponents new];
        endDateComps.hour = [[endTime componentsSeparatedByString:@":"][0] integerValue];
        endDateComps.minute = [[endTime componentsSeparatedByString:@":"][1] integerValue];
        endDateComps.second = 0;
        endDateComps.year = referenceDateComponents.year;
        endDateComps.month = referenceDateComponents.month;
        endDateComps.day = referenceDateComponents.day;
        endDateComps.timeZone = [NSTimeZone systemTimeZone];
        NSDate *endDate = [calendar dateFromComponents:endDateComps];

        if (!withinOpeningHoursDefinition)
        {
            withinOpeningHoursDefinition = [self date:referenceDate isBetweenDate:startDate andDate:endDate];
        }
        else
            break;
    }

    return withinOpeningHoursDefinition;
}

+ (NSArray *)daysTodayYesterdayTomorrowFromDay:(NSString *)day
{
    NSArray *arr;
    if ([day isEqualToString:@"monday"])
    {
        arr = [NSArray arrayWithObjects:@"sunday",@"monday",@"tuesday", nil];
    }
    else if ([day isEqualToString:@"tuesday"])
    {
        arr = [NSArray arrayWithObjects:@"monday",@"tuesday",@"wednesday", nil];
    }
    else if ([day isEqualToString:@"wednesday"])
    {
        arr = [NSArray arrayWithObjects:@"tuesday",@"wednesday",@"thursday", nil];
    }
    else if ([day isEqualToString:@"thursday"])
    {
        arr = [NSArray arrayWithObjects:@"wednesday",@"thursday",@"friday", nil];
    }
    else if ([day isEqualToString:@"friday"])
    {
        arr = [NSArray arrayWithObjects:@"thursday",@"friday",@"saturday", nil];
    }
    else if ([day isEqualToString:@"saturday"])
    {
        arr = [NSArray arrayWithObjects:@"friday",@"saturday",@"sunday", nil];
    }
    else if ([day isEqualToString:@"sunday"])
    {
        arr = [NSArray arrayWithObjects:@"saturday",@"sunday",@"monday", nil];
    }
    return arr;
}

+ (NSDate *)dateByAddingDays:(NSInteger)numDays FromDate:(NSDate *)aDate
{
    NSDateComponents *components = [NSDateComponents new];
    [components setDay:numDays];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    return [gregorian dateByAddingComponents:components toDate:aDate options:0];
}

+ (NSDate *)dateTomorrow:(NSDate *)aDate
{
    return [self dateByAddingDays:1 FromDate:aDate];
}

+ (NSDate *)dateYesterday:(NSDate *)aDate
{
    return [self dateByAddingDays:-1 FromDate:aDate];
}

+ (BOOL)date:(NSDate*)date isBetweenDate:(NSDate*)beginDate andDate:(NSDate*)endDate
{
    return (([date compare:beginDate] != NSOrderedAscending) && ([date compare:endDate] != NSOrderedDescending));
}

//+ (BOOL)date:(NSDate *)referenceDate withinOpeningHoursDefinition:(NSDictionary *)openingHoursDict
//{
//    BOOL withinOpeningHoursDefinition = NO;
//    
//    NSString *weekdayString = [referenceDate descriptionWithCalendarFormat:@"%A"
//                                                                  timeZone:[NSTimeZone localTimeZone]
//                                                                    locale:[[NSUserDefaults standardUserDefaults] dictionaryRepresentation]];
//    
//    NSDateComponents *referenceDateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitDay|NSCalendarUnitMonth|NSCalendarUnitYear|NSCalendarUnitTimeZone
//                                                                                fromDate:referenceDate];
//    
//    NSString *valStrTimeBlocks = openingHoursDict[[weekdayString lowercaseString]];
//    NSArray *timeSlotsWithStrings = [valStrTimeBlocks componentsSeparatedByString:@"|"];
//    
//    for (NSString *timeSlot in timeSlotsWithStrings)
//    {
//        NSArray *timeSlotComponents = [timeSlot componentsSeparatedByString:@"-"];
//        NSString *startTime = timeSlotComponents[kStartTimeIndex];
//        NSString *endTime = timeSlotComponents[kEndTimeIndex];
//        
//        NSCalendar *calendar = [NSCalendar currentCalendar];
//        [calendar setTimeZone: [NSTimeZone systemTimeZone]];
//        
//        // We'll setup the days to start from last week to next week with respect to today
//        // e.g. if today is monday, then,
//        // Setup Start Date
//        NSDateComponents *startDateComps = [NSDateComponents new];
//        startDateComps.hour = [[startTime componentsSeparatedByString:@":"][kHourIndex] integerValue];
//        startDateComps.minute = [[startTime componentsSeparatedByString:@":"][kMinuteIndex] integerValue];
//        startDateComps.second = 0;
//        startDateComps.year = referenceDateComponents.year;
//        startDateComps.month = referenceDateComponents.month;
//        startDateComps.day = referenceDateComponents.day;
//        startDateComps.timeZone = [NSTimeZone systemTimeZone];
//        NSDate *startDate = [calendar dateFromComponents:startDateComps];
//        
//        // Setup End Date
//        NSDateComponents *endDateComps = [NSDateComponents new];
//        endDateComps.hour = [[endTime componentsSeparatedByString:@":"][0] integerValue];
//        endDateComps.minute = [[endTime componentsSeparatedByString:@":"][1] integerValue];
//        endDateComps.second = 0;
//        endDateComps.year = referenceDateComponents.year;
//        endDateComps.month = referenceDateComponents.month;
//        endDateComps.day = referenceDateComponents.day;
//        endDateComps.timeZone = [NSTimeZone systemTimeZone];
//        NSDate *endDate = [calendar dateFromComponents:endDateComps];
//        
//        if (!withinOpeningHoursDefinition)
//        {
//            withinOpeningHoursDefinition = [self date:referenceDate isBetweenDate:startDate andDate:endDate];
//        }
//        else
//            break;
//    }
//    
//    // The method below checks from yesterday, today and tomorrow
//    //    NSArray *daysTodayYesterdayTomorrowFromDay = [self daysTodayYesterdayTomorrowFromDay:[weekdayString lowercaseString]];
//    //    for (NSString *dayKey in daysTodayYesterdayTomorrowFromDay)
//    //    {
//    //        NSString *valStrTimeBlocks = openingHoursDict[dayKey];
//    //        NSArray *timeSlotsWithStrings = [valStrTimeBlocks componentsSeparatedByString:@"|"];
//    //        for (NSString *timeSlot in timeSlotsWithStrings)
//    //        {
//    //            NSArray *timeSlotComponents = [timeSlot componentsSeparatedByString:@"-"];
//    //            NSString *startTime = timeSlotComponents[kStartTimeIndex];
//    //            NSString *endTime = timeSlotComponents[kEndTimeIndex];
//    //
//    //            NSCalendar *calendar = [NSCalendar currentCalendar];
//    //            [calendar setTimeZone: [NSTimeZone systemTimeZone]];
//    //
//    //            // We'll setup the days to start from last week to next week with respect to today
//    //            // e.g. if today is monday, then,
//    //            // Setup Start Date
//    //            NSDateComponents *startDateComps = [NSDateComponents new];
//    //            startDateComps.hour = [[startTime componentsSeparatedByString:@":"][kHourIndex] integerValue];
//    //            startDateComps.minute = [[startTime componentsSeparatedByString:@":"][kMinuteIndex] integerValue];
//    //            startDateComps.second = 0;
//    //            startDateComps.year = referenceDateComponents.year;
//    //            startDateComps.month = referenceDateComponents.month;
//    //            startDateComps.day = referenceDateComponents.day;
//    //            startDateComps.timeZone = [NSTimeZone systemTimeZone];
//    //            NSDate *startDate = [calendar dateFromComponents:startDateComps];
//    //
//    //            // Setup End Date
//    //            NSDateComponents *endDateComps = [NSDateComponents new];
//    //            endDateComps.hour = [[endTime componentsSeparatedByString:@":"][0] integerValue];
//    //            endDateComps.minute = [[endTime componentsSeparatedByString:@":"][1] integerValue];
//    //            endDateComps.second = 0;
//    //            endDateComps.year = referenceDateComponents.year;
//    //            endDateComps.month = referenceDateComponents.month;
//    //            endDateComps.day = referenceDateComponents.day;
//    //            endDateComps.timeZone = [NSTimeZone systemTimeZone];
//    //            NSDate *endDate = [calendar dateFromComponents:endDateComps];
//    //
//    //            if (!withinOpeningHoursDefinition)
//    //            {
//    //                withinOpeningHoursDefinition = [self date:referenceDate isBetweenDate:startDate andDate:endDate];
//    //            }
//    //            else
//    //                break;
//    //        }
//    //        if (withinOpeningHoursDefinition) break;
//    //    }
//    
//    return withinOpeningHoursDefinition;
//}

@end

