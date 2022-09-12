//
//  STDateHelper.h
//  eRegCard
//
//  Created by SamsoDeveloper on 5/15/19.
//  Copyright © 2019 Samsotech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface STDateHelper : NSObject

@property (nonatomic) BOOL isBirthDate;

- (NSString*)convertDateString:(NSString*)dateString
                    fromFormat:(NSString*)format
                      toFormat:(NSString*)newFormat;

- (NSDate*)dateFromString:(NSString*)dateString;
- (NSDate*)dateFromString:(NSString*)dateString withFormat:(NSString*)dateFormat;
- (NSString*)convertDate:(NSDate*)date toFormat:(NSString*)format;
- (NSString*)convertDate:(NSDate *)date toFormat:(NSString *)format timeZone:(NSTimeZone*)timeZone;

- (BOOL)dateString:(NSString*)dateString
     isEarlierThan:(NSString*)dateString2
        dateFormat:(NSString*)dateFormat;

@end

NS_ASSUME_NONNULL_END
