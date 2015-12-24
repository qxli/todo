//
//  QXLeftSideTableViewCell.m
//  todo
//
//  Created by qxli on 15/10/26.
//  Copyright © 2015年 qxli. All rights reserved.
//

#import "QXLeftSideTableViewCell.h"
#import "common.h"

@implementation QXLeftSideTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.notifyNum.text = @"";
    self.itemNum.text = @"";
    self.itemIcon.font = [UIFont fontWithName:@"Wundercon-Light" size:20];
    self.itemLabel.font = [UIFont boldSystemFontOfSize:14.5];
    self.itemNum.font = [UIFont boldSystemFontOfSize:14.5];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
//    if (selected) {
//        self.itemLabel.textColor = [UIColor whiteColor];
//    } else {
//        self.itemLabel.textColor = [UIColor orangeColor];
//    }
}

//- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
//    [super setHighlighted:highlighted animated:animated];
//    if (highlighted) {
//        self.itemLabel.textColor = [UIColor whiteColor];
//    } else {
//        self.itemLabel.textColor = [UIColor blackColor];
//    }
//}

@end
