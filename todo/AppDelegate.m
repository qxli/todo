//
//  AppDelegate.m
//  todo
//
//  Created by qxli on 15/10/5.
//  Copyright © 2015年 qxli. All rights reserved.
//

#import "AppDelegate.h"
#import "QXItemTableViewController.h"
#import "QXItemStore.h"
#import <AFNetworking/AFNetworking.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import <AdSupport/AdSupport.h>
#import "common.h"
#import "MMDrawerController.h"
#import "QXLeftSideTableViewController.h"

@interface AppDelegate ()
@property (nonatomic,strong) MMDrawerController *drawerController;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
#if 0
    QXItemTableViewController *ivc = [[QXItemTableViewController alloc] init];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:ivc];
//    navController.navigationBar.barTintColor = UIColorFromHex(0x099aff);
//    navController.navigationBar.translucent = NO;
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//    self.window.rootViewController = ivc;
    self.window.rootViewController = navController;
#else
    UIViewController *leftSideTableViewController = [[QXLeftSideTableViewController alloc] init];
    UIViewController *ivc = [[QXItemTableViewController alloc] init];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:ivc];
//    UINavigationController *leftSideNavController = [[UINavigationController alloc] initWithRootViewController:cycleTableViewController];
    self.drawerController = [[MMDrawerController alloc] initWithCenterViewController:navController leftDrawerViewController:leftSideTableViewController];
    [self.drawerController setShowsShadow:NO];
    [self.drawerController setRestorationIdentifier:@"MMDrawer"];
    [self.drawerController setMaximumRightDrawerWidth:150.0];
    [self.drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeBezelPanningCenterView];
    [self.drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    [self.drawerController setMaximumLeftDrawerWidth:200];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = self.drawerController;
#endif
    [self.window makeKeyAndVisible];
    [self sendUserInfo];
    
#if 0
    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]) {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
    }
#else
    UIMutableUserNotificationAction *acceptAction = [[UIMutableUserNotificationAction alloc] init];
    acceptAction.identifier = @"ACCEPT_IDENTIFIER";
    acceptAction.title = @"推迟一会";
    acceptAction.activationMode = UIUserNotificationActivationModeBackground;
    acceptAction.destructive = NO;
    acceptAction.authenticationRequired = NO;
    
    UIMutableUserNotificationAction *declineAction = [[UIMutableUserNotificationAction alloc] init];
    declineAction.identifier = @"DECLINE_IDENTIFIER";
    declineAction.title = @"我知道了";
    declineAction.activationMode = UIUserNotificationActivationModeBackground;
    declineAction.destructive = YES;
    declineAction.authenticationRequired = NO;
    
    UIMutableUserNotificationCategory *inviteCategory = [[UIMutableUserNotificationCategory alloc] init];
    inviteCategory.identifier = @"INVITE_CATEGORY";
//    [inviteCategory setActions:@[acceptAction]
//                    forContext:UIUserNotificationActionContextDefault]; // 弹框
    [inviteCategory setActions:@[acceptAction, declineAction]
                    forContext:UIUserNotificationActionContextMinimal]; // 通知栏
    
    NSSet *categories = [NSSet setWithObjects:inviteCategory, nil];
    UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:categories];
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
//    [[UIApplication sharedApplication] registerForRemoteNotifications];
    
//    UILocalNotification* localNotification = [[UILocalNotification alloc] init];
//    localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:10];
//    localNotification.alertBody = @"Testing";
//    localNotification.category = @"INVITE_CATEGORY"; //  Same as category identifier
//    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
#endif
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:[[[QXItemStore instance] allUnCheckItems] count]];
    BOOL isSuccess = [[QXItemStore instance] saveItem];
    if (!isSuccess) {
        NSLog(@"save data failed!");
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


- (void)sendUserInfo {
    NSString * systemVersion = [[UIDevice currentDevice] systemVersion];// 7.0 6.0 etc
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    NSString * valueImsi= [[NSString stringWithFormat:@"%@",info.subscriberCellularProvider.carrierName] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
//    NSString *valueImsi = @"";
    NSString *valueIDFA = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    NSString *atom = [NSString stringWithFormat:@"cv=%@&imsi=%@&idfa=%@", systemVersion, valueImsi, valueIDFA];
    NSString *url = [NSString stringWithFormat:@"http://59.151.12.36:9090/serviceinfo?%@", atom];
    NSLog(@"serviceinfo url:%@", url);
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"res=%@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (operation.isCancelled) {
            return;
        }
    }];
    [operation start];
}

@end
