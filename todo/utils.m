//
//  utils.m
//  todo
//
//  Created by qxli on 15/12/8.
//  Copyright © 2015年 qxli. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "utils.h"
#import "logger.h"

@implementation sp

+ (void)setLocalNotify:(NSString *)title
              fireDate:(NSDate *)date
        repeatInterval:(NSInteger)interval
                   key:(NSString *)key {
    UILocalNotification *note = [[UILocalNotification alloc] init];
    note.alertBody = title;
    note.fireDate = date;
    note.repeatInterval = interval;
    NSDictionary *infoDict = [NSDictionary dictionaryWithObject:key forKey:@"key"];
    note.userInfo = infoDict;
    note.category = @"IDENTIFIER_CATEGORY";
    [[UIApplication sharedApplication] scheduleLocalNotification:note];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm +0800"];
    NSString *dateString = [dateFormatter stringFromDate:date];
    DDLogDebug(@"Setting a reminder for %@", dateString);
}

+ (int)intervalSinceNow: (NSDate *) theDate {
    NSTimeInterval late=[theDate timeIntervalSince1970]*1;
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    dat=  [self getNowDateFromatAnDate:dat];
    NSTimeInterval now=[dat timeIntervalSince1970]*1;
    NSString *timeString=@"";
    NSTimeInterval cha=now-late;
    if (cha/86400>1) {
        timeString = [NSString stringWithFormat:@"%f", cha/86400];
        timeString = [timeString substringToIndex:timeString.length-7];
        return [timeString intValue];
    }
    return -1;
}

+ (NSDate *)getNowDateFromatAnDate:(NSDate *)anyDate
{
    //设置源日期时区
    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];//或GMT
    //设置转换后的目标日期时区
    NSTimeZone* destinationTimeZone = [NSTimeZone localTimeZone];
    //得到源日期与世界标准时间的偏移量
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:anyDate];
    //目标日期与本地时区的偏移量
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:anyDate];
    //得到时间偏移量的差值
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    //转为现在时间
    NSDate* destinationDateNow = [[NSDate alloc] initWithTimeInterval:interval sinceDate:anyDate];
    return destinationDateNow;
}

+ (NSDate *)dateFromString:(NSString *)dateString{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    return destDate;
}

//获得某日是周几
+ (int)getTodayisWeek:(NSDate *)today {
    today = [self getNowDateFromatAnDate:today];
    NSCalendar*calendar = [NSCalendar currentCalendar];
    NSDateComponents*comps;
    [comps setWeekday:0];
    comps =[calendar components:(NSCalendarUnitWeekday)fromDate:today];
    NSInteger weekday = [comps weekday]; // 星期几（注意，周日是“1”，周一是“2”。。。。）
    int  factWeekDay;
    //默认是周日开始
    switch (weekday) {
        case 1:
            factWeekDay = 7  ;
            break;
        case 2:
            factWeekDay = 1  ;
            break;
        case 3:
            factWeekDay = 2  ;
            break;
        case 4:
            factWeekDay = 3  ;
            break;
        case 5:
            factWeekDay = 4  ;
            break;
        case 6:
            factWeekDay = 5  ;
            break;
        case 7:
            factWeekDay = 6  ;
            break;
        default:
            break;
    }
    return  factWeekDay;
}
@end