//
//  QXItem.m
//  todo
//
//  Created by qxli on 15/10/5.
//  Copyright © 2015年 qxli. All rights reserved.
//

#import "QXItem.h"

@implementation QXItem

- (instancetype)initWithItemName:(NSString *)name Content:(NSString *)content Date:(NSDate *)date
{
    self = [super init];
    if (self) {
        _Name = name;
        _Content = @"";
        _dateCreated = [NSDate alloc];
        _dateAlarm = date;
        NSUUID *uuid = [[NSUUID alloc] init];
        _Key = [uuid UUIDString];
        _isChecked = NO;
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
        _listId = [aCoder decodeInt64ForKey:@"itemListId"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.Name forKey:@"itemName"];
    [aCoder encodeObject:self.dateCreated forKey:@"itemDateCreated"];
    [aCoder encodeObject:self.Key forKey:@"itemKey"];
    [aCoder encodeObject:self.dateAlarm forKey:@"itemDateAlarm"];
    [aCoder encodeInt64:self.listId forKey:@"itemListId"];
}

@end
