//
//  NSDate+Extension.m
//  GSEWallet
//
//  Created by user on 07/10/2018.
//  Copyright © 2018 VeslaChi. All rights reserved.
//

#import "NSDate+Extension.h"

@implementation NSDate (Extension)

- (NSString *)deltaStringFromNow{
    NSDate *date = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unit = NSCalendarUnitDay  | NSCalendarUnitHour | NSCalendarUnitMinute ;
    NSDateComponents *compas = [calendar components:unit fromDate:self toDate:date options:0];
    return [self deltaStringFromNow:compas];
    
    //return [self deltaStringFromNow:[self deltaFromNow]];
}

- (NSString *)deltaStringFromNow:(NSDateComponents *)components{
    
    NSMutableString * delta = [NSMutableString string];
    if (components.year > 0 && components.year != NSNotFound) {
        NSString * look = NSLocalizedString(@"years", nil);
        components.year == 1 ? look = NSLocalizedString(@"year", nil) : nil;
        [delta appendString:[NSString stringWithFormat:@"%@ %@ ",@(components.year),look]];
    }
    if (components.month > 0 && components.month != NSNotFound) {
        NSString * look = NSLocalizedString(@"months", nil);
        components.month == 1 ? look = NSLocalizedString(@"month", nil) : nil;
        [delta appendString:[NSString stringWithFormat:@"%@ %@ ",@(components.month),look]];
    }
    if (components.day > 0 && components.day != NSNotFound) {
        NSString * look = NSLocalizedString(@"days", nil);
        components.day == 1 ? look = NSLocalizedString(@"day", nil) : nil;
        [delta appendString:[NSString stringWithFormat:@"%@ %@ ",@(components.day),look]];
    }
    if (components.hour > 0 && components.hour != NSNotFound) {
        NSString * look = NSLocalizedString(@"hrs", nil);
        components.hour == 1 ? look = NSLocalizedString(@"hr", nil) : nil;
        [delta appendString:[NSString stringWithFormat:@"%@ %@ ",@(components.hour),look]];
    }
    if ( components.day <= 3 && components.minute > 0 && components.minute != NSNotFound) {
        NSString * look = NSLocalizedString(@"mins", nil);
        components.minute == 1 ? look = NSLocalizedString(@"min", nil) : nil;
        [delta appendString:[NSString stringWithFormat:@"%@ %@ ",@(components.minute),look]];
    }
    if (!delta.length) {
        NSString * look = NSLocalizedString(@"Just now", nil);
        [delta appendString:look];
    }else{
        NSString * ago = NSLocalizedString(@"ago", nil);
        [delta appendString:ago];
    }
    
    return delta;
}
- (NSDateComponents *)deltaFromNow{
    return [self deltaFrom:[NSDate date]];
}

- (NSDateComponents *)deltaFrom:(NSDate *)date{
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unit =  NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *compas = [calendar components:unit fromDate:self toDate:date options:0];
    
    return compas;
}

- (BOOL)isThisYear{

    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSInteger nowYear = [calendar component:NSCalendarUnitYear fromDate:[NSDate date]];
    NSInteger selfYear = [calendar component:NSCalendarUnitYear fromDate:self];
    return nowYear == selfYear;
}

- (BOOL)isTodayInCalendar{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unit = NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear;
    NSDateComponents *nowComp = [calendar components:unit fromDate:[NSDate date]];
    NSDateComponents *selfComp = [calendar components:unit fromDate:self];

    return nowComp.year == selfComp.year
    && nowComp.month == selfComp.month
    && nowComp.day == selfComp.day;
}

- (BOOL)isToday{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSString *nowString = [formatter stringFromDate:[NSDate date]];
    NSString *selfString = [formatter stringFromDate:self];
    return nowString == selfString;
}

- (BOOL)isYestoday{
    NSDate *nowDate = [[NSDate date] dateWithYMD];
    NSDate *selfDate = [self dateWithYMD];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *cmps = [calendar components:NSCalendarUnitDay fromDate:selfDate toDate:nowDate options:0];
    return cmps.day == 1;
}

- (NSDate *)dateWithYMD{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSString *selfString = [formatter stringFromDate:self];
    return [formatter dateFromString:selfString];
}

- (NSString *)dateString{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSString *selfString = [formatter stringFromDate:self];
    return selfString;
}
@end
