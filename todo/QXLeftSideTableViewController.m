//
//  QXLeftSideTableViewController.m
//  todo
//
//  Created by qxli on 15/10/25.
//  Copyright © 2015年 qxli. All rights reserved.
//

#import "QXLeftSideTableViewController.h"
#import "common.h"
#import "QXLeftSideTableViewCell.h"
#import "QXItemTableViewController.h"
#import "UIViewController+MMDrawerController.h"
#import "QXItemStore.h"
#import "QXItem.h"


@interface QXLeftSideTableViewController ()
@property (nonatomic, strong) UIImageView *lineView;
@property (nonatomic) NSInteger indexRow;

@end

@implementation QXLeftSideTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"QXLeftSideTableViewCell" bundle:nil]
         forCellReuseIdentifier:@"QXLeftSideTableViewCell"];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (instancetype)init
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        self.tableView.separatorStyle = NO;
//        self.tableView.backgroundColor = UIColorFromHex(0xededed);
        self.indexRow = 0;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 70;
    } else {
        return 0.1f;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        NSInteger count = [[QXItemStore instance] allItemsListCount];
        return count;
    } else {
        return 1;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        UIView *aView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CC_Screen_Width, 40)];
        CGRect aRect = CGRectMake(15*CC_Factor_iPhone6_375, 30, 30, 30);
        UILabel *loginLabel = [[UILabel alloc] initWithFrame:aRect];
        loginLabel.font = [UIFont fontWithName:@"Wundercon-Light" size:25];
        loginLabel.text = [NSString stringWithUTF8String:"\ue003"];
        [aView addSubview:loginLabel];
        
        UILabel *searchLabel = [[UILabel alloc] initWithFrame:CGRectMake(CC_Screen_Width-160*CC_Factor_iPhone6_375, 30, 30, 30)];
        searchLabel.font = [UIFont fontWithName:@"Wundercon-Light" size:25];
        searchLabel.text = [NSString stringWithUTF8String:"\ue002"];
        [aView addSubview:searchLabel];
        
        UILabel *setLabel = [[UILabel alloc] initWithFrame:CGRectMake(CC_Screen_Width-120*CC_Factor_iPhone6_375, 30, 30, 30)];
        setLabel.font = [UIFont fontWithName:@"Wundercon-Light" size:25];
        setLabel.text = [NSString stringWithUTF8String:"\ue001"];
        [aView addSubview:setLabel];
        return aView;
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QXLeftSideTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QXLeftSideTableViewCell"
                                                                    forIndexPath:indexPath];
    if (indexPath.section == 0) {
        // Configure the cell...
        NSDictionary *itemDic = nil;
        NSArray *uncheckArray = nil;
        switch (indexPath.row) {
            case 0:
                itemDic = [[QXItemStore instance] getItemDic:indexPath.row];
                uncheckArray = [itemDic valueForKey:@"uncheck"];
                cell.itemLabel.text = [itemDic valueForKey:@"name"];
                cell.itemIcon.text = @"A";
                break;
            case 1:
                uncheckArray = [[QXItemStore instance] getItemFromNowTime];
                cell.itemLabel.text = @"今天";
                cell.itemIcon.text = @"b";
                break;
            case 2:
                uncheckArray = [[QXItemStore instance] getItemFromWeek];
                cell.itemLabel.text = @"本周";
                cell.itemIcon.text = @"F";
                break;
        }
        
        cell.contentView.backgroundColor = [UIColor clearColor];
        int notifyNum = 0;
        for (QXItem *item in uncheckArray) {
            if (item.dateAlarm) {
                notifyNum++;
            }
        }
        cell.itemNum.text = @"";
        cell.notifyNum.text = @"";
        if (notifyNum > 0) {
            cell.notifyNum.text = [NSString stringWithFormat:@"%d", notifyNum];
        }
        if ([uncheckArray count] > 0) {
            cell.itemNum.text = [NSString stringWithFormat:@"%ld", [uncheckArray count]];
        }
        if (indexPath.row == self.indexRow) {
//            [cell setSelected:NO];
            cell.itemLabel.textColor = [UIColor whiteColor];
            cell.itemIcon.textColor = [UIColor whiteColor];
            cell.itemNum.textColor = [UIColor whiteColor];
            cell.contentView.backgroundColor = UIColorFromHex(0x38bfff);
        } else {
            cell.itemLabel.textColor = [UIColor blackColor];
            cell.itemIcon.textColor = [UIColor blueColor];
            cell.itemNum.textColor = [UIColor blackColor];
        }
        cell.itemIcon.hidden = NO;
    } else {
        cell.itemLabel.text = @"add";
        cell.itemIcon.hidden = YES;
        cell.itemNum.text = @"";
        cell.notifyNum.text = @"";
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    cell.backgroundColor = UIColorFromHex(0x1eb6ff);
    if (indexPath.section == 0) {
        QXItemTableViewController *itemView= [[QXItemTableViewController alloc] init];
        NSDictionary *itemDic = [[QXItemStore instance] getItemDic:indexPath.row];
        switch (indexPath.row) {
            case 0:
                itemView.checkList = [itemDic valueForKey:@"check"];
                itemView.uncheckList = [itemDic valueForKey:@"uncheck"];
                break;
            case 1:
                itemView.uncheckList = [[QXItemStore instance] getItemFromNowTime];
                break;
            case 2:
                itemView.uncheckList = [[QXItemStore instance] getItemFromWeek];
                itemView.isShowAdd = NO;
                break;
        }
        UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:itemView];
        [self.mm_drawerController setCenterViewController:nav withCloseAnimation:YES completion:nil];
        
        self.indexRow = indexPath.row;
        [tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section]
                 withRowAnimation:UITableViewRowAnimationNone];
        [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    } else {
        [[QXItemStore instance] addItemList:@"new"];
        NSInteger lastRow = [[QXItemStore instance] allItemsListCount]-1;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:lastRow inSection:0];
        [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

- (UIImageView *)lineView
{
    if (_lineView) {
        return _lineView;
    }
    // 分割线
    _lineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 1.0f, 12.0f)];
    _lineView.center = CGPointMake(_lineView.center.x, self.tableView.bounds.size.height/2.0f);
    UIGraphicsBeginImageContext(_lineView.frame.size);   //开始画线
    [_lineView.image drawInRect:CGRectMake(0, 0, _lineView.frame.size.width, _lineView.frame.size.height)];
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);  //设置线条终点形状
    CGFloat lengths[2] = {0,2};
    CGContextRef line = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(line, [UIColor redColor].CGColor);
    CGContextSetLineDash(line, 0, lengths, 2);  //画虚线
    CGContextMoveToPoint(line, 0.0f, 0.0f);    //开始画线
    CGContextAddLineToPoint(line, .0f, 12.0f);
    CGContextStrokePath(line);
    _lineView.image = UIGraphicsGetImageFromCurrentImageContext();
    return _lineView;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
