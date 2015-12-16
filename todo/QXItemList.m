//
//  QXItemList.m
//  todo
//
//  Created by qxli on 15/12/8.
//  Copyright © 2015年 qxli. All rights reserved.
//

#import "QXItemList.h"

@implementation QXItemList

- (instancetype)initWithName:(NSString *)name {
    self = [super init];
    if (self) {
        NSUUID *uuid = [[NSUUID alloc] init];
        _listId = [uuid UUIDString];
        _listName = name;
    }
    return self;
}

@end
