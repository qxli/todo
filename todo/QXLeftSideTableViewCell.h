//
//  QXLeftSideTableViewCell.h
//  todo
//
//  Created by qxli on 15/10/26.
//  Copyright © 2015年 qxli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"

@interface QXLeftSideTableViewCell : SWTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *itemIcon;
@property (weak, nonatomic) IBOutlet UILabel *itemLabel;
@property (weak, nonatomic) IBOutlet UILabel *itemNum;
@property (weak, nonatomic) IBOutlet UILabel *notifyNum;
@property (strong, nonatomic) NSString *listId;

@end
