//
//  QXItemStore.m
//  todo
//
//  Created by qxli on 15/10/6.
//  Copyright © 2015年 qxli. All rights reserved.
//

#import "QXItemStore.h"
#import "QXItem.h"

@interface QXItemStore()
@property (nonatomic) NSMutableArray *unCheckItems;
@property (nonatomic) NSMutableArray *checkItems;
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
        NSString *path = [self itemArchivePath];
        _unCheckItems = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        _checkItems = [[NSMutableArray alloc] init];
        if (!_unCheckItems) {
            _unCheckItems = [[NSMutableArray alloc] init];
        }
//        if (!_items) {
//            _items = [[NSMutableArray alloc] init];
//            QXItem *item = [[QXItem alloc] initWithItemName:@"这个提醒设置了时间" Content:nil Date:[[NSDate alloc] init]];
//            [self addItem:item];
//        }
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

- (void)addUnCheckItem:(QXItem *)item
{
    [self.unCheckItems insertObject:item atIndex:0];
}

- (void)addCheckItem:(QXItem *)item
{
    [self.checkItems insertObject:item atIndex:0];
//    [self.checkItems addObject:item];
}

- (NSString *)itemArchivePath
{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    return [path stringByAppendingPathComponent:@"items.data"];
}

- (BOOL)saveItem
{
    NSString *path = [self itemArchivePath];
    return [NSKeyedArchiver archiveRootObject:self.unCheckItems toFile:path];
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
