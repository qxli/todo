//
//  QXDetailTableViewController.m
//  todo
//
//  Created by qxli on 15/10/6.
//  Copyright © 2015年 qxli. All rights reserved.
//

#import "QXDetailTableViewController.h"
#import "QXItemStore.h"
#import "QXCycleTableViewController.h"
#import "utils.h"

static NSString *kDatePickerID = @"datePicker";
static NSString *kOtherCell = @"otherCell";
static NSString *ktextFieldCell = @"textFieldCell";

@interface QXDetailTableViewController () <UITextFieldDelegate,UIGestureRecognizerDelegate>

@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) UIDatePicker *datePicker;
@property (assign) NSInteger pickerCellRowHeight;
@property (nonatomic, strong) UITextField *nameField;
@property (assign) BOOL dateSwitchOn;
@property (nonatomic, assign) BOOL datePickerShow;
@property (nonatomic, strong) NSMutableDictionary* indexPath;
@property (nonatomic, strong) UIView *markView;
@property (nonatomic, strong) UILabel *markLabel;

@end

@implementation QXDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                           action:@selector(keyboardHide:)];
    tapGestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    //NSArray *Common = [[NSBundle mainBundle] loadNibNamed:@"Common" owner:self options:nil];
    //UITableViewCell *pickerViewCellToCheck = Common[0];
    //self.pickerCellRowHeight = pickerViewCellToCheck.frame.size.height;
    
    //[self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kOtherCell];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kDatePickerID];
    //[self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kDatePickerID];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    if (self.item.dateAlarm) {
        self.dateSwitchOn = YES;
    }
    
    self.datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(18, 0, 300, 200)];
    if (self.datePicker != nil)
    {
        NSDate *date = [NSDate date];
        if (self.item.dateAlarm) {
            date = self.item.dateAlarm;
        }
        [self.datePicker setDate:date animated:NO];
        [self.datePicker addTarget:self action:@selector(datePickerChanged:) forControlEvents:UIControlEventValueChanged];
    }
    
    self.markView = [[UIView alloc] initWithFrame:CGRectMake(18, 10, 300, 200)];
    self.markView.backgroundColor = [UIColor clearColor];
    UILabel *markLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 20)];
    markLabel.text = @"备注";
    [self.markView addSubview:markLabel];
    UITextField * textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 200, 100)];
    [self.markView addSubview:textField];
    
    NSIndexPath *nameIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    self.indexPath[@"name"] = nameIndexPath;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
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
        navItem.title = @"详细信息";
        UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(saveSetting)];
        navItem.rightBarButtonItem = bbi;
    }
    return self;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else if(section == 1) {
        if (self.datePickerShow) {
            return 4;
        }
        if (self.dateSwitchOn) {
            return 3;
        } else {
            return 1;
        }
    } else if (section == 2){
        return 1;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.datePickerShow && indexPath.section == 1 && indexPath.row == 2) {
        return 200;
        //return self.pickerCellRowHeight;
    }
    if (indexPath.section == 2 && indexPath.row == 0) {
        return 200;
    }
    return self.tableView.rowHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    QXItem *item = self.item;
    UITableViewCell *cell = nil;
    NSString *cellID = kOtherCell;
    switch (indexPath.section) {
        case 0:{
            if(indexPath.row == 0) {
                //cellID = ktextFieldCell;
                cell = [tableView dequeueReusableCellWithIdentifier:cellID];
                self.nameField = [[UITextField alloc] initWithFrame:CGRectMake(16, 0, cell.bounds.size.width, cell.bounds.size.height)];
                self.nameField.adjustsFontSizeToFitWidth = YES;
                self.nameField.text = item.Name;
                self.nameField.placeholder = @"提醒事项";
                [cell.contentView addSubview:self.nameField];
                //            if (!cell) {
                //                NSArray *Common = [[NSBundle mainBundle] loadNibNamed:@"Common" owner:self options:nil];
                //                cell = Common[1];
                //            }
            }
            break;
        }
        case 1: {
            if (indexPath.row == 0){
                cell = [tableView dequeueReusableCellWithIdentifier:cellID];
                UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
                if (self.item.dateAlarm) {
                    [switchView setOn:YES animated:NO];
                    self.dateSwitchOn = YES;
                }
                [switchView addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
                cell.accessoryView = switchView;
                cell.textLabel.text = @"在指定时间提醒我";
            }
            
            if (self.dateSwitchOn) {
                if (indexPath.row == 1){
                    //cell = [tableView dequeueReusableCellWithIdentifier:cellID];
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
                    cell.textLabel.text = @"提醒时间";
                    cell.detailTextLabel.text = [self.dateFormatter stringFromDate:item.dateAlarm];
                }else if (indexPath.row == 2){
                    if (self.datePickerShow) {
                        cellID = kDatePickerID;
                        cell = [tableView dequeueReusableCellWithIdentifier:cellID];
                        [self.datePicker setDate:item.dateAlarm animated:NO];
                        [cell.contentView addSubview:self.datePicker];
                    } else {
                        cell = [tableView dequeueReusableCellWithIdentifier:cellID];
                        cell.textLabel.text = @"重复";
                        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    }
                }
            }
            break;
        }
        case 2:{
            if (indexPath.row == 0) {
                cell = [tableView dequeueReusableCellWithIdentifier:cellID];
                [cell.contentView addSubview:self.markView];
//                cell.textLabel.text = @"备注";
            }
        }
    }
    return cell;
}

- (void)saveSetting
{
    QXItem *item = self.item;
    BOOL isNew = NO;
    if (!item ) {
        item = [[QXItem alloc] init];
        isNew = YES;
    }
    item.Name = self.nameField.text;
//    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
//    item.dateAlarm = [self.dateFormatter dateFromString:cell.detailTextLabel.text];
    if (isNew) {
//        [[QXItemStore instance] addItem:item];
    }
    if (item.dateAlarm) {
        NSInteger repeatInterval = 0;
        switch (item.cycle) {
            case 1:
                repeatInterval = NSCalendarUnitHour;
                break;
            case 2:
                repeatInterval = NSCalendarUnitDay;
                break;
            case 3:
                repeatInterval = NSCalendarUnitWeekday;
                break;
            case 4:
                repeatInterval = NSCalendarUnitMonth;
                break;
        }
        [sp setLocalNotify:item.Name
                  fireDate:item.dateAlarm
            repeatInterval:repeatInterval
                       key:item.Key];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        if (indexPath.row == 1) {
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            [self.tableView beginUpdates];
            if (cell.detailTextLabel.text) {
                cell.textLabel.text = cell.detailTextLabel.text;
                cell.detailTextLabel.text = nil;
                cell.textLabel.textColor = [UIColor blueColor];
                self.datePickerShow = YES;
                NSIndexPath *cellIndexPath = [NSIndexPath indexPathForRow:indexPath.row + 1 inSection:1];
                [self.tableView insertRowsAtIndexPaths:@[cellIndexPath]
                                      withRowAnimation:UITableViewRowAnimationFade];
            } else {
                self.datePickerShow = NO;
                cell.detailTextLabel.text = cell.textLabel.text;
                cell.textLabel.text = @"提醒时间";
                cell.textLabel.textColor = [UIColor blackColor];
                NSIndexPath *cellIndexPath = [NSIndexPath indexPathForRow:indexPath.row + 1 inSection:1];
                [self.tableView deleteRowsAtIndexPaths:@[cellIndexPath]
                                      withRowAnimation:UITableViewRowAnimationFade];
            }
            [self.tableView endUpdates];
        }
        if ((indexPath.row == 2 && !self.datePickerShow) || indexPath.row == 3) {
            QXCycleTableViewController *cycleTableViewController = [[QXCycleTableViewController alloc] init];
            cycleTableViewController.item = self.item;
            [self.navigationController pushViewController:cycleTableViewController animated:YES];
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (void)datePickerChanged:(id)sender
{
    UIDatePicker *datePicker = sender;
    NSIndexPath *cellIndexPath = [NSIndexPath indexPathForRow:1 inSection:1];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:cellIndexPath];
    cell.textLabel.text = [self.dateFormatter stringFromDate:datePicker.date];
    self.item.dateAlarm = datePicker.date;
}

- (void)switchChanged:(id)sender
{
    [self.tableView beginUpdates];
    UISwitch * switchView = (UISwitch *)sender;
    if (switchView.on) {
        self.dateSwitchOn = YES;
        self.item.dateAlarm = [NSDate dateWithTimeIntervalSinceNow:360];
        NSIndexPath *cellIndexPath = [NSIndexPath indexPathForRow:1 inSection:1];
        [self.tableView insertRowsAtIndexPaths:@[cellIndexPath]
                              withRowAnimation:UITableViewRowAnimationFade];
        cellIndexPath = [NSIndexPath indexPathForRow:2 inSection:1];
        [self.tableView insertRowsAtIndexPaths:@[cellIndexPath]
                              withRowAnimation:UITableViewRowAnimationFade];
    } else {
        self.dateSwitchOn = NO;
        self.item.dateAlarm = nil;
        self.datePickerShow = NO;
        NSInteger cellCount = [self.tableView numberOfRowsInSection:1];
        for (int i = 1; i < cellCount; i++) {
            NSIndexPath *cellIndexPath = [NSIndexPath indexPathForRow:i inSection:1];
            [self.tableView deleteRowsAtIndexPaths:@[cellIndexPath]
                                  withRowAnimation:UITableViewRowAnimationFade];
        }
        
        // 关闭本地通知
        UILocalNotification *notification = nil;
        for(UILocalNotification *notify in [[UIApplication sharedApplication] scheduledLocalNotifications]) {
            if([[notify.userInfo objectForKey:@"key"] isEqualToString:self.item.Key]) {
                notification = notify;
                break;
            }
        }
        [[UIApplication sharedApplication] cancelLocalNotification:notification];
    }
    [self.tableView endUpdates];
}

#pragma mark - keyboard
- (void)keyboardHide:(UITapGestureRecognizer *)ges
{
    [self.view endEditing:YES];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    // Get the new view controller using [segue destinationViewController].
//    // Pass the selected object to the new view controller.
//}


@end
