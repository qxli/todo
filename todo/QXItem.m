//
//  QXItem.m
//  todo
//
//  Created by qxli on 15/10/5.
//  Copyright © 2015年 qxli. All rights reserved.
//

#import "QXItem.h"

@implementation QXItem

- (instancetype)initWithItemName:(NSString *)name
{
    self = [super init];
    if (self) {
        _Name = name;
        _Content = @"";
        _dateCreated = [[NSDate alloc] init];
        _dateAlarm = nil;
        NSUUID *uuid = [[NSUUID alloc] init];
        _Key = [uuid UUIDString];
        _isChecked = NO;
        _listId = 0;
        _cycle = 0;
    }
    return self;
}

- (instancetype)initWithItemName:(NSString *)name date:(NSString *)dateString
{
    self = [super init];
    if (self) {
        _Name = name;
        _Content = @"";
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
        NSDate *date= [dateFormatter dateFromString:dateString];
        _dateCreated = date;
        _dateExpire = date;
        _dateAlarm = nil;
        NSUUID *uuid = [[NSUUID alloc] init];
        _Key = [uuid UUIDString];
        _isChecked = NO;
        _listId = 0;
        _cycle = 0;
        _listKey = @"default";
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aCoder
{
    self = [super init];
    if (self) {
        _Name = [aCoder decodeObjectForKey:@"itemName"];
        _dateCreated = [aCoder decodeObjectForKey:@"itemDateCreated"];
        _Key = [aCoder decodeObjectForKey:@"itemKey"];
        _dateAlarm = [aCoder decodeObjectForKey:@"itemDateAlarm"];
        _isChecked = [aCoder decodeBoolForKey:@"itemIsCheck"];
        _listKey = [aCoder decodeObjectForKey:@"itemListId"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.Name forKey:@"itemName"];
    [aCoder encodeObject:self.dateCreated forKey:@"itemDateCreated"];
    [aCoder encodeObject:self.Key forKey:@"itemKey"];
    [aCoder encodeObject:self.dateAlarm forKey:@"itemDateAlarm"];
    [aCoder encodeBool:self.isChecked forKey:@"itemIsCheck"];
    [aCoder encodeObject:self.listKey forKey:@"itemListId"];
}

@end
