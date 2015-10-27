//
//  QXItemStore.m
//  todo
//
//  Created by qxli on 15/10/6.
//  Copyright © 2015年 qxli. All rights reserved.
//

#import "QXItemStore.h"
#import "QXItem.h"
#import "QXItemList.h"

@interface QXItemStore()
@property (nonatomic) NSMutableArray *unCheckItems;
@property (nonatomic) NSMutableArray *checkItems;

@property (nonatomic) NSMutableArray *items;
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
        _items = [NSKeyedUnarchiver unarchiveObjectWithFile:[self getItemArchivePath]];
        _itemLists = [NSKeyedUnarchiver unarchiveObjectWithFile:[self getItemListArchivePath]];
        
        
        if (!_checkItems) {
            _checkItems = [[NSMutableArray alloc] init];
            QXItem *item = [[QXItem alloc] initWithItemName:@"这里显示完成的提醒" Content:nil Date:nil];
            [self addCheckItem:item];
        }
        if (!_unCheckItems) {
            _unCheckItems = [[NSMutableArray alloc] init];
            QXItem *item;
            item = [[QXItem alloc] initWithItemName:@"向又滑动可以删除" Content:nil Date:nil];
            [self addUnCheckItem:item];
            item = [[QXItem alloc] initWithItemName:@"点击我可以设置提醒时间" Content:nil Date:nil];
            [self addUnCheckItem:item];
            item = [[QXItem alloc] initWithItemName:@"上边的输入框可以添加提醒" Content:nil Date:nil];
            [self addUnCheckItem:item];
        }
    }
    return self;
}

- (NSArray *)allItems
{
    return self.unCheckItems;
}

- (NSArray *)allUnCheckItems
{
    return self.unCheckItems;
}

- (NSArray *)allCheckItems
{
    return self.checkItems;
}

- (void)addItem:(QXItem *)item
{
    [self.unCheckItems insertObject:item atIndex:0];
}

- (void)addUnCheckItem:(QXItem *)item {
    [self addUnCheckItem:item index:0];
}

- (void)addUnCheckItem:(QXItem *)item index:(NSInteger)index {
    [self.unCheckItems insertObject:item atIndex:index];
}

- (void)addCheckItem:(QXItem *)item {
    [self addCheckItem:item index:0];
}

- (void)addCheckItem:(QXItem *)item index:(NSInteger)index{
    [self.checkItems insertObject:item atIndex:index];
}

- (NSString *)getItemArchivePath {
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    path = [path stringByAppendingPathComponent:@"items.data"];
    return path;
}

- (NSString *)getItemListArchivePath {
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    path = [path stringByAppendingPathComponent:@"itemLists.data"];
    return path;
}

- (BOOL)saveItem
{
    BOOL ret = YES;
    NSString *path = nil;
    path = [self getItemArchivePath];
    [NSKeyedArchiver archiveRootObject:self.items toFile:path];
    path = [self getItemListArchivePath];
    [NSKeyedArchiver archiveRootObject:self.itemLists toFile:path];
    return ret;
}

- (void)removeItem:(QXItem *)item isCheck:(BOOL)check
{
    if (check) {
        [self.checkItems removeObjectIdenticalTo:item];
    } else{
        [self.unCheckItems removeObjectIdenticalTo:item];
    }
}

@end
