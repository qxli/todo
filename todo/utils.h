//
//  utils.h
//  todo
//
//  Created by qxli on 15/12/8.
//  Copyright © 2015年 qxli. All rights reserved.
//

#ifndef utils_h
#define utils_h


@interface sp: NSObject

//+ (instancetype) instance;
+ (int)intervalSinceNow: (NSDate *) theDate;
+ (int)getTodayisWeek:(NSDate *)today;
+ (void)setLocalNotify:(NSString *)title
              fireDate:(NSDate *)date
        repeatInterval:(NSInteger)interval
                   key:(NSString *)key;

@end
#endif /* utils_h */
