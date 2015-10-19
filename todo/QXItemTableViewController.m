//
//  QXItemTableViewController.m
//  todo
//
//  Created by qxli on 15/10/5.
//  Copyright © 2015年 qxli. All rights reserved.
//

#import "QXItemTableViewController.h"
#import "QXItem.h"
#import "QXItemStore.h"
#import "QXDetailTableViewController.h"
#import "common.h"

#define UIColorFromHex(s) \
    [UIColor colorWithRed:(((s & 0xFF0000) >> 16))/255.0 \
                    green:(((s & 0xFF00) >> 8))/255.0 \
                     blue:((s & 0xFF))/255.0  alpha:1.0]

#define headViewHeight 55

@interface QXItemTableViewController () <UITextFieldDelegate>

@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIView *checkView;
@property (nonatomic, strong) UIView *cellView;

@end

@implementation QXItemTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                           action:@selector(keyboardHide:)];
    tapGestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGestureRecognizer];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    UIImageView *backImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    [backImageView setImage:[UIImage imageNamed:@"back"]];
    self.tableView.backgroundView = backImageView;
//    self.tableView.backgroundColor = UIColorFromHex(0x6DC1FC);
    self.tableView.separatorStyle = NO;
    self.headerView = [self getSectionView:0];
    self.checkView = [self getSectionView:1];
    self.cellView = [self getCellView];
}

- (UIView *)getSectionView:(NSInteger)section {
    UIView *aView = nil;
    if (section == 0) {
        aView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CC_Screen_Width, headViewHeight)];
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake((CC_Screen_Width-355*CC_Factor_iPhone6_375)/2, 10*CC_Factor_iPhone6_375, 355*CC_Factor_iPhone6_375, headViewHeight-20)];
        textField.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.55];
        textField.layer.cornerRadius = 3.0f;
        textField.tintColor = [UIColor whiteColor];
        UIView *paddingView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10*CC_Factor_iPhone6_375, headViewHeight-20)];
        textField.leftView = paddingView;
        textField.leftViewMode = UITextFieldViewModeAlways;
        textField.textColor = [UIColor whiteColor];
        textField.delegate = self;
        textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"添加一个任务…" attributes:@{NSForegroundColorAttributeName: [UIColor lightTextColor]}];
        textField.layer.cornerRadius = 4.0f;
        textField.layer.borderColor = [UIColor clearColor].CGColor;
        textField.layer.shadowColor = [UIColor blackColor].CGColor;
        textField.layer.shadowOffset = CGSizeMake(2.0f, 2.0f);
        textField.layer.shadowRadius = 4.0f;
        textField.layer.shadowPath = [[UIBezierPath bezierPathWithRect:textField.layer.bounds] CGPath];
        [textField.layer setShadowOpacity:0.1f];
        [aView addSubview:textField];
    } else if (section == 1) {
        aView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CC_Screen_Width, headViewHeight)];
        aView.backgroundColor = [UIColor clearColor];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        CGRect frame = CGRectMake((CC_Screen_Width-355*CC_Factor_iPhone6_375)/2, 15*CC_Factor_iPhone6_375, 100*CC_Factor_iPhone6_375, 20*CC_Factor_iPhone6_375);
        button.frame = frame;   // match the button's size with the image size
        button.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.55];
        [button setTitle:@"已完成任务" forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:12.0];
        [aView addSubview:button];
        button.layer.cornerRadius = 4.0f;
        button.layer.borderColor = [UIColor clearColor].CGColor;
        button.layer.shadowColor = [UIColor blackColor].CGColor;
        button.layer.shadowOffset = CGSizeMake(2.0f, 2.0f);
        button.layer.shadowRadius = 4.0f;
        button.layer.shadowPath = [[UIBezierPath bezierPathWithRect:button.layer.bounds] CGPath];
        [button.layer setShadowOpacity:0.1f];
    }
    return aView;
}

- (UIView *)getCellView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(10*CC_Factor_iPhone6_375, 0, CC_Screen_Width-(20*CC_Factor_iPhone6_375), 38*CC_Factor_iPhone6_375)];
    view.backgroundColor = [UIColor whiteColor];
    view.layer.cornerRadius = 3.5f;
    view.layer.borderColor = [UIColor clearColor].CGColor;
    //    view.layer.shadowColor = [UIColor blackColor].CGColor;
    //    view.layer.shadowOffset = CGSizeMake(2.0f, 2.0f);
    //    view.layer.shadowRadius = 4.0f;
    //    view.layer.shadowPath = [[UIBezierPath bezierPathWithRect:view.layer.bounds] CGPath];
    //    [view.layer setShadowOpacity:0.1f];
    
    UIImage *image = nil;
    image = [UIImage imageNamed:@"Unchecked Checkbox-50"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    CGRect frame = CGRectMake(10*CC_Factor_iPhone6_375, 12*CC_Factor_iPhone6_375, 16*CC_Factor_iPhone6_375, 16*CC_Factor_iPhone6_375);
    button.frame = frame;   // match the button's size with the image size
    button.tag = 3;
    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button addTarget:self action:@selector(checkButtonTapped:event:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(38*CC_Factor_iPhone6_375, 10*CC_Factor_iPhone6_375,  CC_Screen_Width-38*CC_Factor_iPhone6_375, 20*CC_Factor_iPhone6_375)];
    label.tag = 2;
    label.font = [UIFont systemFontOfSize:15.0];
    [view addSubview:label];
    view.tag = 1;
    return view;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (instancetype)init
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        UINavigationItem *navItem = self.navigationItem;
        navItem.title = @"任务清单";
//        UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewItem:)];
//        navItem.rightBarButtonItem = bbi;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSUInteger count = 0;
    if (section == 0) {
        count = [[[QXItemStore instance] allUnCheckItems] count];
    } else {
        count = [[[QXItemStore instance] allCheckItems] count];
    }
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return headViewHeight;
    } else{
        if ([[[QXItemStore instance] allCheckItems] count] <= 0) {
            return 0;
        }
    }
    return 40.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return self.headerView;
    }else{
        if ([[[QXItemStore instance] allCheckItems] count] <= 0) {
            return nil;
        }
        return self.checkView;
    }
    return nil;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    QXItem *item = [[QXItem alloc] initWithItemName:textField.text Content:nil Date:nil];
    [[QXItemStore instance] addUnCheckItem:item];
    NSInteger lastRow = [[[QXItemStore instance] allUnCheckItems] indexOfObject:item];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:lastRow inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
    textField.text = @"";
    return NO;
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    if (section == 0) {
//        return @"";
//    }
//    return @"已完成";
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    cell.backgroundColor = [UIColor clearColor];
#if 1
    UIView *view = self.cellView;
    UIButton *button = (UIButton *)[view viewWithTag:3];
    button.tag = indexPath.row;
    QXItem *item = nil;
    UIImage *image = nil;
    if (indexPath.section == 0) {
        NSArray *items = [[QXItemStore instance] allUnCheckItems];
        item = items[indexPath.row];
        image = [UIImage imageNamed:@"Unchecked Checkbox-50"];
        cell.textLabel.textColor = [UIColor blackColor];
    } else{
        NSArray *items = [[QXItemStore instance] allCheckItems];
        item = items[indexPath.row];
        image = [UIImage imageNamed:@"Checked Checkbox-50"];
        cell.textLabel.textColor = [UIColor grayColor];
    }
    UILabel *label = (UILabel *)[view viewWithTag:2];
    label.text = item.Name;
    view.backgroundColor = [UIColor whiteColor];
    [cell.contentView addSubview:view];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
#else
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(10*CC_Factor_iPhone6_375, 0, CC_Screen_Width-(20*CC_Factor_iPhone6_375), 38*CC_Factor_iPhone6_375)];
    view.backgroundColor = [UIColor whiteColor];
    view.layer.cornerRadius = 3.5f;
    view.layer.borderColor = [UIColor clearColor].CGColor;
//    view.layer.shadowColor = [UIColor blackColor].CGColor;
//    view.layer.shadowOffset = CGSizeMake(2.0f, 2.0f);
//    view.layer.shadowRadius = 4.0f;
//    view.layer.shadowPath = [[UIBezierPath bezierPathWithRect:view.layer.bounds] CGPath];
//    [view.layer setShadowOpacity:0.1f];
    
    QXItem *item = nil;
    UIImage *image = nil;
    if (indexPath.section == 0) {
        NSArray *items = [[QXItemStore instance] allUnCheckItems];
        item = items[indexPath.row];
        image = [UIImage imageNamed:@"Unchecked Checkbox-50"];
        cell.textLabel.textColor = [UIColor blackColor];
    } else{
        NSArray *items = [[QXItemStore instance] allCheckItems];
        item = items[indexPath.row];
        image = [UIImage imageNamed:@"Checked Checkbox-50"];
        cell.textLabel.textColor = [UIColor grayColor];
    }
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    CGRect frame = CGRectMake(10*CC_Factor_iPhone6_375, 12*CC_Factor_iPhone6_375, 16*CC_Factor_iPhone6_375, 16*CC_Factor_iPhone6_375);
    button.frame = frame;   // match the button's size with the image size
    button.tag = indexPath.row;
    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button addTarget:self action:@selector(checkButtonTapped:event:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(38*CC_Factor_iPhone6_375, 10*CC_Factor_iPhone6_375,  CC_Screen_Width-38*CC_Factor_iPhone6_375, 20*CC_Factor_iPhone6_375)];
    label.text = item.Name;
    label.font = [UIFont systemFontOfSize:15.0];
    [view addSubview:label];
    view.tag = 1;
    [cell.contentView addSubview:view];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
#endif
    return cell;
}

- (void)checkButtonTapped:(id)sender event:(id)event
{
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:currentTouchPosition];
    if (indexPath != nil) {
        [self tableView:self.tableView accessoryButtonTappedForRowWithIndexPath:indexPath];
    }
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UIButton *button = (UIButton*)cell.accessoryView;
    UIImage *image = [UIImage imageNamed:@"Checked Checkbox-50"];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    QXItem *item = nil;
    if (indexPath.section == 0) {
        NSArray *items = [[QXItemStore instance] allUnCheckItems];
        item = items[indexPath.row];
        [[QXItemStore instance] addCheckItem:item];
        NSInteger firstRow = [[[QXItemStore instance] allCheckItems] indexOfObject:item];
        NSIndexPath *indexPathNew = [NSIndexPath indexPathForRow:firstRow inSection:1];
        [self.tableView insertRowsAtIndexPaths:@[indexPathNew] withRowAnimation:UITableViewRowAnimationAutomatic];
        [[QXItemStore instance] removeItem:item isCheck:NO];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    } else{
        NSArray *items = [[QXItemStore instance] allCheckItems];
        item = items[indexPath.row];
        [[QXItemStore instance] addUnCheckItem:item];
        NSInteger firstRow = [[[QXItemStore instance] allUnCheckItems] indexOfObject:item];
        NSIndexPath *indexPathNew = [NSIndexPath indexPathForRow:firstRow inSection:0];
        [self.tableView insertRowsAtIndexPaths:@[indexPathNew] withRowAnimation:UITableViewRowAnimationAutomatic];
        [[QXItemStore instance] removeItem:item isCheck:YES];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    UIView *view = (UIView *)[cell.contentView viewWithTag:1];
    [view setBackgroundColor:[UIColor colorWithRed:0.5058 green:0.7725 blue:0.9176 alpha:1.0]];
    QXDetailTableViewController *detailViewController = [[QXDetailTableViewController alloc] init];
    NSArray *items = [[QXItemStore instance] allItems];
    QXItem *selectedItem = items[indexPath.row];
    detailViewController.item = selectedItem;
    [self.navigationController pushViewController:detailViewController animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

#pragma mark - action

- (void)addNewItem:(id)sender
{
    QXDetailTableViewController *detailViewController = [[QXDetailTableViewController alloc] init];
    [self.navigationController pushViewController:detailViewController animated:YES];
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSArray *items;
        if (indexPath.section == 0) {
            items = [[QXItemStore instance] allUnCheckItems];
        } else {
            items = [[QXItemStore instance] allCheckItems];
        }
        QXItem *item = items[indexPath.row];
        BOOL check = indexPath.section == 0 ? NO : YES;
        [[QXItemStore instance] removeItem:item isCheck:check];
        [self.tableView beginUpdates];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView endUpdates];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        NSLog(@"UITableViewCellEditingStyleInsert");
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}


#pragma mark - keyboard
- (void)keyboardHide:(UITapGestureRecognizer *)ges
{
    [self.view endEditing:YES];
}

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
