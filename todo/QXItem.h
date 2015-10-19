//
//  QXItem.h
//  todo
//
//  Created by qxli on 15/10/5.
//  Copyright © 2015年 qxli. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QXItem : NSObject

@property (nonatomic, strong) NSString *Name;
@property (nonatomic, strong) NSString *Content;
@property (nonatomic, strong) NSDate *dateCreated;
@property (nonatomic, strong) NSString *Key;
@property (nonatomic, assign) BOOL isChecked;
@property (nonatomic) BOOL isComplete;

- (instancetype) initWithItemName:(NSString *)name Content:(NSString *)content Date:(NSDate *)date;
@end
