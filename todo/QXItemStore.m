//
//  QXItemStore.m
//  todo
//
//  Created by qxli on 15/10/6.
//  Copyright © 2015年 qxli. All rights reserved.
//

#import "QXItemStore.h"
#import "QXItem.h"
#import "logger.h"
#import "utils.h"

@interface QXItemStore()
@property (nonatomic) NSMutableArray *itemLists;
@end

@implementation QXItemStore

- (instancetype)init
{
    @throw [NSException exceptionWithName:@"Singleton" reason:@"Use +[QXItemStore instance]" userInfo:nil];
    return nil;
}

+ (instancetype)instance
{
    static QXItemStore *instance = nil;
    if (!instance) {
        instance = [[self alloc] initPrivate];
    }
    return instance;
}

- (instancetype)initPrivate
{
    self = [super init];
    if (self) {
        _itemLists = [NSKeyedUnarchiver unarchiveObjectWithFile:[self getItemListArchivePath]];
//        _itemLists = [NSKeyedUnarchiver unarchiveObjectWithFile:[self getItemListArchivePath]];
        if (!_itemLists) {
            _itemLists = [NSMutableArray array];
            NSMutableDictionary *oneItem = [NSMutableDictionary dictionary];
            NSMutableArray *checkArray = [NSMutableArray array];
            NSMutableArray *uncheckArray = [NSMutableArray array];
            QXItem *item;
            item = [[QXItem alloc] initWithItemName:@"向又滑动可以删除" date:@"2015-11-16 00:00:00"];
            [uncheckArray addObject:item];
            item = [[QXItem alloc] initWithItemName:@"点击我可以设置提醒时间" date:@"2015-11-27 00:00:00"];
            [uncheckArray addObject:item];
            item = [[QXItem alloc] initWithItemName:@"上边的输入框可以添加提醒" date:@"2015-11-24 00:00:00"];
            [uncheckArray addObject:item];
            [oneItem setValue:@"收集箱" forKey:@"name"];
            [oneItem setValue:checkArray forKey:@"check"];
            [oneItem setValue:uncheckArray forKey:@"uncheck"];
            [_itemLists addObject:oneItem];
            
            [self addItemList:@"今天"];
            [self addItemList:@"本周"];
        }
        
    }
    return self;
}

- (void)setItemCheck:(NSString *)key {
    for (NSDictionary *itemDic in self.itemLists) {
        NSArray *uncheckArray = [itemDic objectForKey:@"uncheck"];
        for (QXItem *item in uncheckArray) {
            if( [item.Key isEqualToString:key]) {
                item.isChecked = YES;
            }
        }
    }
    
}

- (NSInteger)unCheckCount:(NSInteger) listId {
    NSMutableDictionary *itemDic = [_itemLists objectAtIndex:listId];
    NSInteger count = 0;
    NSArray *itemArray = [itemDic objectForKey:@"uncheck"];
    for (QXItem *item in itemArray) {
        if (item.listId == listId && !item.isChecked) {
            count++;
        }
    }
    return count;
}

- (NSInteger)checkCount:(NSInteger) listId {
    NSMutableDictionary *itemDic = [_itemLists objectAtIndex:listId];
    NSArray *itemArray = [itemDic objectForKey:@"check"];
    NSInteger count = 0;
    for (QXItem *item in itemArray) {
        if (item.listId == listId && item.isChecked) {
            count++;
        }
    }
    return count;
}

- (QXItem *)getCheckItemFromRow:(NSInteger)row listId:(NSInteger)listId {
    QXItem *it = nil;
    NSInteger count = -1;
    NSMutableDictionary *itemDic = [_itemLists objectAtIndex:listId];
    NSArray *itemArray = [itemDic objectForKey:@"check"];
    for (QXItem *item in itemArray) {
        if (listId == item.listId && !item.isChecked) {
            count++;
        }
        if (row == count) {
            it = item;
            break;
        }
    }
    return it;
}

- (QXItem *)getUncheckItemFromRow:(NSInteger)row listId:(NSInteger)listId {
    QXItem *it = nil;
    NSInteger count = -1;
    NSMutableDictionary *itemDic = [_itemLists objectAtIndex:listId];
    NSArray *itemArray = [itemDic objectForKey:@"uncheck"];
    for (QXItem *item in itemArray) {
        if (listId == item.listId && item.isChecked) {
            count++;
        }
        if (row == count) {
            it = item;
            break;
        }
    }
    return it;
}

- (void)addUnCheckItem:(QXItem *)item listId:(NSInteger)listId index:(NSInteger)index {
    NSMutableDictionary *itemDic = [_itemLists objectAtIndex:listId];
    NSMutableArray *itemArray = [itemDic objectForKey:@"uncheck"];
    [itemArray insertObject:item atIndex:index];
}

- (void)addCheckItem:(QXItem *)item listId:(NSInteger)listId index:(NSInteger)index{
    NSMutableDictionary *itemDic = [_itemLists objectAtIndex:listId];
    NSMutableArray *itemArray = [itemDic objectForKey:@"check"];
    [itemArray insertObject:item atIndex:index];
}

- (NSString *)getItemListArchivePath {
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    path = [path stringByAppendingPathComponent:@"itemLists.data"];
    NSLog(@"store path=%@", path);
    return path;
}

- (BOOL)saveItem
{
    BOOL ret = YES;
    NSString *path = nil;
    path = [self getItemListArchivePath];
    ret = [NSKeyedArchiver archiveRootObject:self.itemLists toFile:path];
//    path = [self getItemListArchivePath];
//    [NSKeyedArchiver archiveRootObject:self.itemLists toFile:path];
    return ret;
}

- (void)removeItem:(QXItem *)item isCheck:(BOOL)check
{
    if (check) {
//        [self.checkItems removeObjectIdenticalTo:item];
    } else{
//        [self.unCheckItems removeObjectIdenticalTo:item];
    }
}

- (NSInteger) allItemsListCount {
    return [_itemLists count];
}

- (NSDictionary *) getItemDic:(NSInteger)index {
    return [_itemLists objectAtIndex:index];
}

- (void)addItemList:(NSString *)listName {
    NSMutableDictionary *twoItem = [NSMutableDictionary dictionary];
    NSMutableArray *checkArray2 = [NSMutableArray array];
    NSMutableArray *uncheckArray2 = [NSMutableArray array];
    [twoItem setValue:listName forKey:@"name"];
    [twoItem setValue:checkArray2 forKey:@"check"];
    [twoItem setValue:uncheckArray2 forKey:@"uncheck"];
    [_itemLists addObject:twoItem];
}

- (NSMutableArray *)getItemFromWeek {
    NSMutableArray *weekUncheck = [NSMutableArray array];
    for (NSDictionary *itemDic in self.itemLists) {
        NSArray *uncheckArray = [itemDic objectForKey:@"uncheck"];
        for (QXItem *item in uncheckArray) {
            if([sp intervalSinceNow:item.dateAlarm]<7
               && [sp intervalSinceNow:item.dateAlarm]<[sp getTodayisWeek:[NSDate date]]) {
                [weekUncheck addObject:item];
            }
        }
    }
    return weekUncheck;
}

- (NSMutableArray *)getItemFromNowTime {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY/MM/dd"];
    NSString *nowDate = [dateFormatter stringFromDate:[NSDate date]];
    NSMutableArray *uncheck = [NSMutableArray array];
    for (NSDictionary *itemDic in self.itemLists) {
        NSArray *uncheckArray = [itemDic objectForKey:@"uncheck"];
        for (QXItem *item in uncheckArray) {
            NSString *dateString = [dateFormatter stringFromDate:item.dateAlarm];
            if ([nowDate isEqualToString:dateString]) {
                [uncheck addObject:item];
            }
        }
    }
    return uncheck;
}



@end
