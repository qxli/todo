//
//  QXItemList.h
//  todo
//
//  Created by qxli on 15/12/8.
//  Copyright © 2015年 qxli. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QXItemList : NSObject

@property (strong, nonatomic) NSString *listId;
@property (strong, nonatomic) NSString *listName;

- (instancetype)initWithName:(NSString *)name;
@end
