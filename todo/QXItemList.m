//
//  QXItemList.m
//  todo
//
//  Created by qxli on 15/10/27.
//  Copyright © 2015年 qxli. All rights reserved.
//

#import "QXItemList.h"

@implementation QXItemList


- (instancetype)initWithCoder:(NSCoder *)aCoder
{
    self = [super init];
    if (self) {
        _listId = [aCoder decodeInt64ForKey:@"ListId"];
        _listName = [aCoder decodeObjectForKey:@"listName"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.listName forKey:@"listName"];
    [aCoder encodeInt64:self.listId forKey:@"ListId"];
}

@end
