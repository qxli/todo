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
#import "QXItemList.h"

@interface QXItemStore()
@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, strong) NSMutableArray *itemLists;
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
        if (!_itemLists) {
//            _itemLists = [NSMutableArray array];
//            QXItemList *List = [[QXItemList alloc] initWithName:@"收集箱"];
//            [self.itemLists addObject:List];
        }
        
        _items = [self openItem];
        if (!_items) {
            _items = [NSMutableArray array];
            QXItem *item;
            item = [[QXItem alloc] initWithItemName:@"向又滑动可以删除" date:@"2015-12-16 00:00:00"];
            [self.items addObject:item];
            item = [[QXItem alloc] initWithItemName:@"点击我可以设置提醒时间" date:@"2015-12-16 00:00:00"];
            [self.items addObject:item];
            item = [[QXItem alloc] initWithItemName:@"上边的输入框可以添加提醒" date:@"2015-12-17 00:00:00"];
            [self.items addObject:item];
        }
    }
    return self;
}

- (NSMutableArray *)openItem{
        return [NSKeyedUnarchiver unarchiveObjectWithFile:[self getItemListArchivePath]];
//        return [[NSMutableArray alloc] initWithContentsOfFile:[self getItemListArchivePath]];
}


- (void)setItemCheck:(NSString *)key {
    for (NSDictionary *itemDic in self.items) {
        NSArray *uncheckArray = [itemDic objectForKey:@"uncheck"];
        for (QXItem *item in uncheckArray) {
            if( [item.Key isEqualToString:key]) {
                item.isChecked = YES;
            }
        }
    }
    
}

- (NSInteger)unCheckCount:(NSInteger) listId {
    return 0;
    NSMutableDictionary *itemDic = [_items objectAtIndex:listId];
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
    return 0;
    NSMutableDictionary *itemDic = [_items objectAtIndex:listId];
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
    NSMutableDictionary *itemDic = [_items objectAtIndex:listId];
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
    NSMutableDictionary *itemDic = [_items objectAtIndex:listId];
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

- (void)addItem:(QXItem *)item {
    [_items insertObject:item atIndex:0];
}

- (void)addCheckItem:(QXItem *)item listId:(NSInteger)listId index:(NSInteger)index{
    NSMutableDictionary *itemDic = [_items objectAtIndex:listId];
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
    ret = [NSKeyedArchiver archiveRootObject:self.items toFile:[self getItemListArchivePath]];
//    ret = [_itemLists writeToFile:[self getItemListArchivePath] atomically:YES];
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

- (NSInteger)getItemsListCount {
    return [self.itemLists count] + 3;
}

- (NSMutableArray *)getItemList {
    return self.itemLists;
}

- (NSMutableArray *)getItemFromListId:(NSString *)listId check:(BOOL)isCheck {
    NSMutableArray *items = [NSMutableArray array];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY/MM/dd"];
    NSString *nowDate = [dateFormatter stringFromDate:[NSDate date]];
    for (QXItem* item in self.items) {
        if ([listId isEqualToString:@"day"]) {
            NSString *dateAlarmString = [dateFormatter stringFromDate:item.dateAlarm];
            NSString *dateExpireString = [dateFormatter stringFromDate:item.dateExpire];
            if (([nowDate isEqualToString:dateAlarmString]
                 || [nowDate isEqualToString:dateExpireString])
                && item.isChecked == isCheck) {
                [items addObject:item];
            }
        } else if ([listId isEqualToString:@"week"]) {
            if( ([sp intervalSinceNow:item.dateAlarm]<7
                 && [sp intervalSinceNow:item.dateAlarm]<[sp getTodayisWeek:[NSDate date]])
               || ([sp intervalSinceNow:item.dateExpire]<7
                   && [sp intervalSinceNow:item.dateExpire]<[sp getTodayisWeek:[NSDate date]])) {
                [items addObject:item];
            }
        } else {
            if ([listId isEqualToString:item.listKey] && item.isChecked == isCheck) {
                [items addObject:item];
            }
        }
    }
    return items;
}

- (NSDictionary *) getItemDic:(NSInteger)index {
    return [_items objectAtIndex:index];
}

- (void)addItemList:(NSString *)listName {
    NSMutableDictionary *twoItem = [NSMutableDictionary dictionary];
    NSMutableArray *checkArray2 = [NSMutableArray array];
    NSMutableArray *uncheckArray2 = [NSMutableArray array];
    [twoItem setValue:listName forKey:@"name"];
    [twoItem setValue:checkArray2 forKey:@"check"];
    [twoItem setValue:uncheckArray2 forKey:@"uncheck"];
    [_items addObject:twoItem];
}

- (NSMutableArray *)getDayItem {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY/MM/dd"];
    NSString *nowDate = [dateFormatter stringFromDate:[NSDate date]];
    NSMutableArray *items = [NSMutableArray array];
    for (QXItem *item in self.items) {
        NSString *dateString = [dateFormatter stringFromDate:item.dateAlarm];
        if ([nowDate isEqualToString:dateString] && item.isChecked == NO) {
            [items addObject:item];
        }
    }
    return items;
}



@end
