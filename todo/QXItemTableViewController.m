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
#import "QXItemTableViewCell.h"
#import "QXSetTableViewController.h"
#import "MMDrawerController.h"
#import "UIViewController+MMDrawerController.h"


#define headViewHeight 65

@interface QXItemTableViewController () <UITextFieldDelegate,SWTableViewCellDelegate>

@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIView *checkView;
//@property (nonatomic, strong) UIView *cellView;
@property (nonatomic) BOOL isHidden;

@end

@implementation QXItemTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"QXItemTableViewCell" bundle:nil]
         forCellReuseIdentifier:@"QXItemTableViewCell"];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                           action:@selector(keyboardHide:)];
    tapGestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGestureRecognizer];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
//     self.navigationItem.rightBarButtonItem = UIBarButtonSystemItemDone;
    
    UIImageView *backImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    [backImageView setImage:[UIImage imageNamed:@"back"]];
    self.tableView.backgroundView = backImageView;
//    self.tableView.backgroundColor = UIColorFromHex(0xa2d9ff);
//    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = NO;
    self.headerView = [self getSectionView:0];
    self.checkView = [self getSectionView:1];
    self.isHidden = NO;
//    self.cellView = [self getCellView];
}

- (UIView *)getSectionView:(NSInteger)section {
    UIView *aView = nil;
    if (section == 0) {
        aView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CC_Screen_Width, headViewHeight)];
//        aView.backgroundColor = [UIColor blueColor];
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake((CC_Screen_Width-355*CC_Factor_iPhone6_375)/2, (headViewHeight-44)/2*CC_Factor_iPhone6_375, 355*CC_Factor_iPhone6_375, 44)];
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
        aView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CC_Screen_Width, 40)];
//        aView.backgroundColor = [UIColor redColor];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        CGRect frame = CGRectMake((CC_Screen_Width-355*CC_Factor_iPhone6_375)/2, (40-20)*CC_Factor_iPhone6_375/2, 100*CC_Factor_iPhone6_375, 20*CC_Factor_iPhone6_375);
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
        [button addTarget:self action:@selector(sectionButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    }
    return aView;
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
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
        UIImage *image = [UIImage imageNamed:@"Settings-50"];
        [button setBackgroundImage:image forState:UIControlStateNormal];
        [button addTarget:self action:@selector(globalSet:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithCustomView:button];
        navItem.rightBarButtonItem = bbi;
        
        UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(leftDrawerButtonPress:)];
        [navItem setLeftBarButtonItem:leftBarButton animated:YES];
    }
    return self;
}

- (void)globalSet:(id)sender {
    QXSetTableViewController *setTableViewController = [[QXSetTableViewController alloc] init];
    [self.navigationController pushViewController:setTableViewController animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    if ([[[QXItemStore instance] allCheckItems] count] <= 0){
//        return 1;
//    }
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSUInteger count = 0;
    if (section == 0) {
        count = [[[QXItemStore instance] allUnCheckItems] count];
    } else {
        count = [[[QXItemStore instance] allCheckItems] count];
//        if (self.isHidden) {
//            count = 0;
//        }
    }
//    NSLog(@"section=%ld,numberOfRowsInSection=%ld", section, count);
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return headViewHeight;
    } else{
        if ([[[QXItemStore instance] allCheckItems] count] <= 0) {
            return 1;
        }
    }
    return 40.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 46.0;
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

- (NSArray *)rightButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
    view.backgroundColor = [UIColor clearColor];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor redColor];
    button.frame = CGRectMake(0, 0, 55, 44);
    button.layer.cornerRadius = 3.5f;
    button.layer.borderColor = [UIColor clearColor].CGColor;
    [button setBackgroundImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
//    [[button imageView] setContentMode: UIViewContentModeScaleAspectFit];
    button.imageEdgeInsets = UIEdgeInsetsMake(3, 3, 3, 3);
    button.userInteractionEnabled = NO;
    [view addSubview:button];
    [rightUtilityButtons addObject:view];
    
//    [rightUtilityButtons sw_addUtilityButtonWithColor: [UIColor redColor] icon:[UIImage imageNamed:@"delete"]];
    return rightUtilityButtons;
}

- (NSArray *)leftButtons {
    NSMutableArray *leftUtilityButtons = [NSMutableArray new];
    [leftUtilityButtons sw_addUtilityButtonWithColor: [UIColor clearColor] title:@""];
    return leftUtilityButtons;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    QXItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QXItemTableViewCell" forIndexPath:indexPath];
#if 1
    QXItem *item = nil;
    UIImage *image = nil;
    if (indexPath.section == 0) {
        NSArray *items = [[QXItemStore instance] allUnCheckItems];
        item = items[indexPath.row];
        image = [UIImage imageNamed:@"uncheck"];
        cell.itemLabel.textColor = [UIColor blackColor];
        cell.itemView.backgroundColor = [UIColor whiteColor];
        if (item.dateAlarm) {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
            NSString *dateString = [dateFormatter stringFromDate:item.dateAlarm];
            cell.itemLabelBottom.text = dateString;
            cell.itemLabelTop.text = item.Name;
            cell.itemLabel.text = @"";
        } else {
            cell.itemLabel.text = item.Name;
        }
        
    } else{
        NSArray *items = [[QXItemStore instance] allCheckItems];
        item = items[indexPath.row];
        image = [UIImage imageNamed:@"check"];
        cell.itemLabel.textColor = [UIColor grayColor];
        [cell setHidden:NO];
        if (self.isHidden) {
//            [cell setHidden:YES];
        }
        cell.itemView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.70];
        NSAttributedString * title =
        [[NSAttributedString alloc] initWithString:item.Name
                                        attributes:@{NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle)}];
        [cell.itemLabel setAttributedText:title];
    }
    [cell setRightUtilityButtons:[self rightButtons] WithButtonWidth:65.0f];
    [cell setLeftUtilityButtons:[self leftButtons] WithButtonWidth:1000];
    cell.delegate = self;
    [cell.itemButton setImage:image forState:UIControlStateNormal];
    cell.itemButton.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    [cell.itemButton addTarget:self action:@selector(checkButtonTapped:event:) forControlEvents:UIControlEventTouchUpInside];
    
#else
//    view.layer.shadowColor = [UIColor blackColor].CGColor;
//    view.layer.shadowOffset = CGSizeMake(2.0f, 2.0f);
//    view.layer.shadowRadius = 4.0f;
//    view.layer.shadowPath = [[UIBezierPath bezierPathWithRect:view.layer.bounds] CGPath];
//    [view.layer setShadowOpacity:0.1f];
#endif
    return cell;
}

- (void)sectionButtonTapped:(id)sender {
    [self.tableView beginUpdates];
    self.isHidden = YES;
    [self.tableView endUpdates];
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
//    QXItemTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    UIImage *image = [UIImage imageNamed:@"Checked Checkbox-50"];
//    [cell.itemButton setBackgroundImage:image forState:UIControlStateNormal];
    QXItem *item = nil;
    [self.tableView beginUpdates];
    if (indexPath.section == 0) {
        NSArray *items = [[QXItemStore instance] allUnCheckItems];
        item = items[indexPath.row];
        if (!item) {
            NSLog(@"");
        }
        [[QXItemStore instance] addCheckItem:item index:[[[QXItemStore instance] allCheckItems] count]];
        NSInteger firstRow = [[[QXItemStore instance] allCheckItems] indexOfObject:item];
        NSIndexPath *indexPathNew = [NSIndexPath indexPathForRow:firstRow inSection:1];
        [self.tableView insertRowsAtIndexPaths:@[indexPathNew] withRowAnimation:UITableViewRowAnimationAutomatic];
        [[QXItemStore instance] removeItem:item isCheck:NO];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    } else{
        NSArray *items = [[QXItemStore instance] allCheckItems];
        item = items[indexPath.row];
        if (!item) {
            NSLog(@"");
        }
        [[QXItemStore instance] addUnCheckItem:item index:[[[QXItemStore instance] allUnCheckItems] count]];
        NSInteger firstRow = [[[QXItemStore instance] allUnCheckItems] indexOfObject:item];
        NSIndexPath *indexPathNew = [NSIndexPath indexPathForRow:firstRow inSection:0];
        [self.tableView insertRowsAtIndexPaths:@[indexPathNew] withRowAnimation:UITableViewRowAnimationAutomatic];
        [[QXItemStore instance] removeItem:item isCheck:YES];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    [self.tableView endUpdates];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    QXItemTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    [cell.itemView setBackgroundColor:[UIColor colorWithRed:0.5058 green:0.7725 blue:0.9176 alpha:1.0]];
    QXDetailTableViewController *detailViewController = [[QXDetailTableViewController alloc] init];
    NSArray *items;
    if (indexPath.section == 0) {
        items = [[QXItemStore instance] allUnCheckItems];
    } else {
        items = [[QXItemStore instance] allCheckItems];
    }
    QXItem *selectedItem = items[indexPath.row];
    detailViewController.item = selectedItem;
    [self.navigationController pushViewController:detailViewController animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
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

#pragma mark - SWTableViewDelegate

- (BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell {
    // allow just one cell's utility button to be open at once
    return YES;
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell scrollingToState:(SWCellState)state {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    switch (state) {
        case 0:
//            NSLog(@"utility buttons closed");
            break;
        case 1:
            [self tableView:self.tableView accessoryButtonTappedForRowWithIndexPath:indexPath];
            NSLog(@"left utility buttons open");
            break;
        case 2:
//            NSLog(@"right utility buttons open");
            break;
        default:
            break;
    }
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    switch (index) {
        case 0:
            [self tableView:self.tableView commitEditingStyle:UITableViewCellEditingStyleDelete
                                            forRowAtIndexPath:indexPath];
            NSLog(@"left button 0 was pressed");
            break;
        default:
            break;
    }
}


#pragma mark - Button Handlers
-(void)leftDrawerButtonPress:(id)sender{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
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
