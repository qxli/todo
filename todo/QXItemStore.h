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

- (NSArray *) allItems;
- (NSArray *) allUnCheckItems;
- (NSArray *) allCheckItems;
- (void)addItem:(QXItem *)item;
- (void)addUnCheckItem:(QXItem *)item;
- (void)addCheckItem:(QXItem *)item;
- (BOOL)saveItem;
- (void)removeItem:(QXItem *)item isCheck:(BOOL)check;
@end
