//
//  QXItem.h
//  todo
//
//  Created by qxli on 15/10/5.
//  Copyright © 2015年 qxli. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QXItem : NSObject

@property (nonatomic, strong) NSString *Name;       // 提醒名
@property (nonatomic, strong) NSString *Content;
@property (nonatomic, strong) NSDate *dateCreated;  // 创建日期
@property (nonatomic, strong) NSDate *dateAlarm;  // 提醒时间
@property (nonatomic, strong) NSString *Key;
@property (nonatomic, assign) BOOL isChecked;
@property (nonatomic) BOOL isComplete;
@property (nonatomic) NSInteger listId;
@property (nonatomic) NSInteger cycle;

- (instancetype) initWithItemName:(NSString *)name;
- (instancetype) initWithItemName:(NSString *)name date:(NSString *)dateString;
@end
