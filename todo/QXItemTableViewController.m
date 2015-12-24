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

@interface QXItemTableViewController () <UITextFieldDelegate,SWTableViewCellDelegate,UIViewControllerPreviewingDelegate>

@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIView *checkView;
//@property (nonatomic, strong) UIView *cellView;
@property (nonatomic) BOOL isHidden;

@end

@implementation QXItemTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
    [backImageView setImage:[UIImage imageNamed:@"wlbackground11@2x.jpg"]];
    self.tableView.backgroundView = backImageView;
    self.tableView.separatorStyle = NO;
    self.headerView = [self createAddButton];
    self.checkView = [self createLabel];
    self.isHidden = NO;
    
    if(self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable) {
        
        [self registerForPreviewingWithDelegate:self sourceView:self.view];
        
    }
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.tableView reloadData];
}

- (UIView *)createAddButton {
    UIView *aView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CC_Screen_Width, headViewHeight)];
    if (self.isShowAdd) {
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
    }
    return aView;
}

- (UIView *)createLabel {
    UIView *aView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CC_Screen_Width, 40)];
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
    [aView addSubview:button];
    return aView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (instancetype)init
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        UINavigationItem *navItem = self.navigationItem;
        navItem.title = @"任务清单";
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 34, 20.5)];
        label.font = [UIFont fontWithName:@"Wundercon-Light" size:20];
        label.text = @"x";
        UIButton *button =  [UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:CGRectMake(0, 0, 40, 40)];
        [button addTarget:self
                   action:@selector(leftDrawerButtonPress:)
         forControlEvents:UIControlEventTouchUpInside];
        [button addSubview:label];
        UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:button];
        [navItem setLeftBarButtonItem:leftBarButton animated:YES];
        self.isShowAdd = YES;
    }
    return self;
}

- (void)globalSet:(id)sender {
//    QXSetTableViewController *setTableViewController = [[QXSetTableViewController alloc] init];
//    [self.navigationController pushViewController:setTableViewController animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    DDLogDebug(@"%s", __func__);
    self.uncheckList = [[QXItemStore instance] getItemFromListId:self.listId check:NO];
    if (self.isShowAdd) {
        self.checkList = [[QXItemStore instance] getItemFromListId:self.listId check:YES];
    }
    [self.tableView reloadData];
//    [self.tableView setEditing:YES animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([self.checkList count] <= 0) {
        return 1;
    }
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSUInteger count = 0;
    if (section == 0) {
        count = [self.uncheckList count];
    } else {
        count = [self.checkList count];
    }
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        if (self.isShowAdd) {
            return headViewHeight;
        } else {
            return 10;
        }
    } else{
        if ([self.checkList count] <= 0) {
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
        if (self.isShowAdd) {
            return self.headerView;
        } else {
            return nil;
        }
    }else{
        if ([self.checkList count] <= 0) {
            return nil;
        } else {
            return self.checkView;
        }
    }
    return nil;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    QXItem *item = [[QXItem alloc] initWithItemName:textField.text];
    if ([self.listId isEqualToString:@"day"] || [self.listId isEqualToString:@"week"]) {
        item.listKey = @"default";
    } else {
        item.listKey = self.listId;
    }
    [[QXItemStore instance] addItem:item];
    [self.uncheckList insertObject:item atIndex:0];
    NSInteger lastRow = [self.uncheckList indexOfObjectIdenticalTo:item];
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
    QXItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QXItemTableViewCell"
                                                                forIndexPath:indexPath];
    QXItem *item = nil;
    UIImage *image = nil;
    if (indexPath.section == 0) {
        item = [self.uncheckList objectAtIndex:indexPath.row];
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
            cell.itemLabelTop.text = @"";
            cell.itemLabelBottom.text = @"";
        }
        
    } else{
        item = [self.checkList objectAtIndex:indexPath.row];
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
    QXItem *item = nil;
    [self.tableView beginUpdates];
    if (indexPath.section == 0) {
        item = [self.uncheckList objectAtIndex:indexPath.row];
        if (!item) {
            NSLog(@"");
        }
        item.isChecked = YES;
        [self.checkList addObject:item];
        NSInteger firstRow = [self.checkList indexOfObject:item];
        NSIndexPath *indexPathNew = [NSIndexPath indexPathForRow:firstRow inSection:1];
        [self.tableView insertRowsAtIndexPaths:@[indexPathNew] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.uncheckList removeObjectIdenticalTo:item];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        if ([self.checkList count] == 1) {
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:1]
                          withRowAnimation:UITableViewRowAnimationTop];
        }
    } else{
        item = [self.checkList objectAtIndex:indexPath.row];
        if (!item) {
            NSLog(@"");
        }
        item.isChecked = NO;
        [self.uncheckList addObject:item];
        NSInteger firstRow = [self.uncheckList indexOfObject:item];
        NSIndexPath *indexPathNew = [NSIndexPath indexPathForRow:firstRow inSection:0];
        [self.tableView insertRowsAtIndexPaths:@[indexPathNew] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.checkList removeObjectIdenticalTo:item];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        if ([self.checkList count] <=0) {
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:1]
                          withRowAnimation:UITableViewRowAnimationTop];
        }
    }
    [self.tableView endUpdates];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    QXItemTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    [cell.itemView setBackgroundColor:[UIColor colorWithRed:0.5058 green:0.7725 blue:0.9176 alpha:1.0]];
    QXDetailTableViewController *detailViewController = [[QXDetailTableViewController alloc] init];
    QXItem *item = nil;
    if (indexPath.section == 0) {
        item = [self.uncheckList objectAtIndex:indexPath.row];
    } else {
        item = [self.checkList objectAtIndex:indexPath.row];
    }
    detailViewController.item = item;
    [self.navigationController pushViewController:detailViewController animated:YES];
}

//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return NO;
//}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleNone;
}

-(BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

//- (BOOL)tableView:(UITableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return NO;
//}

- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{
    if( sourceIndexPath.section != proposedDestinationIndexPath.section) {
        return sourceIndexPath;
    } else {
        return proposedDestinationIndexPath;
    }
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    id object = [self.uncheckList objectAtIndex:sourceIndexPath.row];
    [self.uncheckList removeObjectAtIndex:sourceIndexPath.row];
    [self.uncheckList insertObject:object atIndex:destinationIndexPath.row];
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
        QXItem *item = nil;
        if (indexPath.section == 0) {
            item = [self.uncheckList objectAtIndex:indexPath.row];
            [self.uncheckList removeObjectIdenticalTo:item];
        } else {
            item = [self.checkList objectAtIndex:indexPath.row];
            [self.checkList removeObjectIdenticalTo:item];
        }
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


#pragma mark - MMDrawerController Button Handlers
-(void)leftDrawerButtonPress:(id)sender{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}


- (UIViewController *)previewingContext:(id<UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location {
    
    NSIndexPath *indexPath =  [self.tableView indexPathForRowAtPoint:location];
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    if(cell != nil ){
        
        QXDetailTableViewController *detailViewController = [[QXDetailTableViewController alloc] init];
        QXItem *item = nil;
        if (indexPath.section == 0) {
            item = [self.uncheckList objectAtIndex:indexPath.row];
        } else {
            item = [self.checkList objectAtIndex:indexPath.row];
        }
        detailViewController.item = item;
        return detailViewController;
        
    }
    
    return nil;
    
}

- (void)previewingContext:(id<UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit {
    
    [self showViewController:viewControllerToCommit sender:self];
    
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
