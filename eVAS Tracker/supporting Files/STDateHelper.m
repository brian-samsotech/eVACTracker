//
//  STDateHelper.m
//  eRegCard
//
//  Created by SamsoDeveloper on 5/15/19.
//  Copyright © 2019 Samsotech. All rights reserved.
//

#import "STDateHelper.h"

// utilities
#import "Constants.h"
#import "NSString+Validation.h"

@implementation STDateHelper
{
    NSDateFormatter *_dateFormatter;
}

#pragma mark - Init
- (id)init
{
    self = [super init];
    
    if(self)
    {
        _dateFormatter = [NSDateFormatter new];
        [_dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
        [_dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    }
    
    return self;
}

#pragma mark - Private

// source: https://medium.com/@imho_ios/converting-yy-to-yyyy-12262bd447b0
- (NSInteger)convertYYintoYYYY:(NSInteger)yearEntry
{
    yearEntry =  yearEntry % 100;  // Being overprotective... this will truncate to YY.
    
    // bday = let centennial = (parsedYear > currentYear) ? "19" : "20"
    // expiry = let centennial = (parsedYear >= 70) ? "19" : "20"

    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear fromDate:[NSDate date]];
    NSInteger baseYear = components.year - 50;
    
    if (self.isBirthDate)
    {
        baseYear = components.year - 99;
    }
    
    NSInteger twoDigitBaseYear = baseYear % 100;
    NSInteger fourDigitEntry = (baseYear - twoDigitBaseYear) + yearEntry;
    
    if (yearEntry < twoDigitBaseYear)
    {
        fourDigitEntry += 100;
    }
    
    return fourDigitEntry;
}

#pragma mark - Public

- (NSString*)convertDateString:(NSString*)dateString
                    fromFormat:(NSString*)format
                      toFormat:(NSString*)newFormat
{
    if([[NSString nullCheck:dateString] length] == 0)
    {
        return @"";
    }
    
    [_dateFormatter setDateFormat:format];
    NSDate *date = [_dateFormatter dateFromString:dateString];
    return [self convertDate:date toFormat:newFormat];
}

- (NSDate*)dateFromString:(NSString*)dateString
{
    if(dateString.length == 0)
    {
        return nil;
    }
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *userDateFormat = [userDefaults stringForKey:str_Defaults_DateFormat];
    if([userDateFormat length] == 0)
    {
        userDateFormat = STDateFormatDisplay;
    }
    
    NSDate *date = nil;
    NSArray *availableFormats = @[
        userDateFormat,
        STDateFormatDisplay,
        STDateFormatDatabase,
        STDateFormatDateTime,
        STDateFormatDateTime2,
        STDateFormatScanner,
        STDateFormatStamp,
        STTimeFormatDisplay
    ];
    
    for (NSString *dateFormat in availableFormats)
    {
        date = [self dateFromString:dateString withFormat:dateFormat];
        
        if(date)
        {
            break;
        }
    }
    
    return date;
}

- (NSDate*)dateFromString:(NSString*)dateString withFormat:(NSString*)dateFormat
{
    [_dateFormatter setDateFormat:dateFormat];
    NSDate *date = [_dateFormatter dateFromString:dateString];
    
    if(date == nil)
    {
        return nil;
    }
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitMonth|
                                                         NSCalendarUnitDay|
                                                         NSCalendarUnitYear|
                                                         NSCalendarUnitHour|
                                                         NSCalendarUnitMinute|
                                                         NSCalendarUnitSecond)
                                               fromDate:date];
    
    components.year = [self convertYYintoYYYY:components.year];
    
    return [calendar dateFromComponents:components];
}

- (NSString*)convertDate:(NSDate*)date toFormat:(NSString*)format
{
    return [self convertDate:date toFormat:format timeZone:[NSTimeZone systemTimeZone]];
}

- (NSString*)convertDate:(NSDate *)date toFormat:(NSString *)format timeZone:(NSTimeZone*)timeZone
{
    if(!date)
    {
        return @"";
    }
    
    [_dateFormatter setDateFormat:format];
    [_dateFormatter setTimeZone:timeZone];
    NSString *dateString = [_dateFormatter stringFromDate:date];
    
    return [NSString nullCheck:dateString];
}

// TODO: NSError
- (BOOL)dateString:(NSString*)dateString
     isEarlierThan:(NSString*)dateString2
        dateFormat:(NSString*)dateFormat
{
    [_dateFormatter setDateFormat:dateFormat];
    
    NSDate *date  = [_dateFormatter dateFromString:dateString];
    NSDate *date2 = [_dateFormatter dateFromString:dateString2];
    
    if(date && date2)
    {
        return [date compare:date2] == NSOrderedAscending;
    }
    
    return NO;
}

@end
