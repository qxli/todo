//
//  QXItemTableViewCell.h
//  todo
//
//  Created by qxli on 15/10/20.
//  Copyright © 2015年 qxli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"

@interface QXItemTableViewCell : SWTableViewCell

@property (weak, nonatomic) IBOutlet UIView *itemView;
@property (weak, nonatomic) IBOutlet UIButton *itemButton;
@property (weak, nonatomic) IBOutlet UILabel *itemLabel;
@property (weak, nonatomic) IBOutlet UILabel *itemLabelTop;
@property (weak, nonatomic) IBOutlet UILabel *itemLabelBottom;
@end
