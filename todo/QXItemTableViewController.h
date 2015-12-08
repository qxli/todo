//
//  QXItemTableViewController.h
//  todo
//
//  Created by qxli on 15/10/5.
//  Copyright © 2015年 qxli. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QXItemTableViewController : UITableViewController

@property (strong, nonatomic) NSMutableArray *uncheckList;
@property (strong, nonatomic) NSMutableArray *checkList;
@property (nonatomic) BOOL isShowAdd;
@end
