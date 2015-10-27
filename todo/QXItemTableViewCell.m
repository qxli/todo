//
//  QXItemTableViewCell.m
//  todo
//
//  Created by qxli on 15/10/20.
//  Copyright © 2015年 qxli. All rights reserved.
//

#import "QXItemTableViewCell.h"
#import "common.h"

@implementation QXItemTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    self.itemView.backgroundColor = [UIColor whiteColor];
    self.itemView.frame = CGRectMake(10, 0, CC_Screen_Width-20, 44);
    self.itemView.layer.cornerRadius = 3.5f;
    self.itemView.layer.borderColor = [UIColor clearColor].CGColor;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.itemLabelTop.text = @"";
    self.itemLabelBottom.text = @"";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
