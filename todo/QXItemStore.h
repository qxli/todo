//
//  QXItemStore.h
//  todo
//
//  Created by qxli on 15/10/6.
//  Copyright © 2015年 qxli. All rights reserved.
//

#import <Foundation/Foundation.h>

@class QXItem;
@interface QXItemStore : NSObject

//@property (nonatomic, readonly) NSArray *allItems;

+ (instancetype) instance;

- (QXItem *)getCheckItemFromRow:(NSInteger)row listId:(NSInteger)listId;
- (QXItem *)getUncheckItemFromRow:(NSInteger)row listId:(NSInteger)listId;
- (void)addCheckItem:(QXItem *)item listId:(NSInteger)listId index:(NSInteger)index;
- (BOOL)saveItem;
- (void)removeItem:(QXItem *)item isCheck:(BOOL)check;
- (void)setItemCheck:(NSString *)key;


- (NSInteger)unCheckCount:(NSInteger) listId;
- (NSInteger)checkCount:(NSInteger) listId;

- (NSDictionary *) getItemDic:(NSInteger)index;
- (void)addItemList:(NSString *)listName;


- (NSInteger) getItemsListCount;
- (NSMutableArray *)getItemList;
- (NSMutableArray *)getItemFromListId:(NSString *)listId check:(BOOL)isCheck;
- (void)addItem:(QXItem *)item;
- (NSMutableArray *)getDayItem;
@end
