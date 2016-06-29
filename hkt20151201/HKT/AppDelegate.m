//
//  AppDelegate.m
//  HKT
//
//  Created by app on 15-5-26.
//  Copyright (c) 2015年 百瑞. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "AFNetworkReachabilityManager.h"
#import "IQKeyboardManager.h"
#import "MobClick.h"
#import "UserManager.h"
#import "AFHTTPRequestOperationManager.h"
#import "AdViewController.h"
#import "CalculatorViewController.h"
#import "recommendViewController.h"
#import "ManagerViewController.h"

@interface AppDelegate ()<UIAlertViewDelegate,UIViewControllerPreviewingDelegate>
{
    UIApplicationShortcutItem* shortItem;
}


@end

@implementation AppDelegate
{
    UserManager *singleApp;
    //    UIView *splashView;
    NSString *checkViewStr;
    UINavigationController *nvc;
    //    UIImageView *imageAd;
}

+ (instancetype)sharedInstance {
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //coreData 工具类初始化 add by Ting
    [CoreDataUtil launch];
    
    application.statusBarStyle = UIStatusBarStyleLightContent;
    
    singleApp = [UserManager shareUserManager];
    checkViewStr = [[NSString alloc] init];
    //极光
    [APService setupWithOption:launchOptions];
    [APService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert) categories:nil];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [APService setBadge:0];
    NSDictionary *remoteNotification = [launchOptions objectForKey: UIApplicationLaunchOptionsRemoteNotificationKey];
    
    NSString *Pagename = remoteNotification[@"source"];
    NSLog(@"remoteNotification == %@",remoteNotification);
    NSUserDefaults *de = [NSUserDefaults standardUserDefaults];
    [de removeObjectForKey:@"Pagename"];
    [de setObject:Pagename forKey:@"Pagename"];
    [de synchronize];
    
    //
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setObject:Pagename forKey:@"vision"];
    [def synchronize];
    
    // 配置键盘
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = NO;
    manager.enableAutoToolbar = NO;
    
    [MobClick startWithAppkey:@"5600e9dc67e58ec5ea000f1e" reportPolicy:BATCH   channelId:nil];
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
    
    [UMSocialData setAppKey:@"5600e9dc67e58ec5ea000f1e"];
    [UMSocialQQHandler setQQWithAppId:@"1104679034" appKey:@"HlZye2rADbhNJhk9" url:@"http://m.berui.com"];
    [UMSocialWechatHandler setWXAppId:@"wx5cac7c367e011ef5" appSecret:@"21b9bd10f40b7b5daae4a8dd62d30977" url:nil];
    [UMSocialSinaHandler openSSOWithRedirectURL:nil];
    
    //广告
    AdViewController *ad = [[AdViewController alloc] init];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    LoginViewController *vc = [[LoginViewController alloc] init];
    nvc = [[UINavigationController alloc] initWithRootViewController:ad];
    ad.SkipStatus = ^(NSString *skipLogin){
        if ([skipLogin isEqualToString:@"skipLogin"]) {
            [nvc setViewControllers:@[vc]];
        }
    };
    

    [nvc.navigationBar setTranslucent:NO];
    
    //白色导航栏文字
    nvc.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    
    [nvc.navigationBar setBarTintColor:[UIColor colorWithHex:0x54b2ed]];
    self.window.rootViewController = nvc;
    
    [application setApplicationIconBadgeNumber:0];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [self ckeckNetWork];
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"3DTouch" object:shortItem.type];
    
    NSUserDefaults *deF = [NSUserDefaults standardUserDefaults];
    NSString *vision = [deF stringForKey: @"Vision"];
    NSLog(@"vision ===== %lu",(unsigned long)vision.length);
    if (vision.length != 0) {
        [self checkVision];
    }

    [self.window makeKeyAndVisible];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application shouldAllowExtensionPointIdentifier:(NSString *)extensionPointIdentifier{
    return NO;
}

// add by wyy
-(void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"3DTouch" object:shortcutItem.type];
}

#pragma mark 更新模块
-(void)checkVision
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:@"https://itunes.apple.com/lookup?id=1044183743" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSArray *arr = [responseObject objectForKey:@"results"];
            for (NSDictionary *dic in arr) {
                NSString *localVersion =[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
                NSLog(@"~~~~~~~~~~~%@  localVersion ==== %@",dic[@"version"],localVersion);
                if (![dic[@"version"] isEqualToString:localVersion]) {
                    checkViewStr = dic[@"trackViewUrl"];
                    
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                                        message:@"版本已有更新，可以去AppStore下载体验！"
                                                                       delegate:self
                                                              cancelButtonTitle:nil
                                                              otherButtonTitles:@"好的，我知道了", nil];
                    [alertView show];
                    
                }
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failure: %@", error.localizedDescription);
    }];
    
}


//add by Ting
-(void)ckeckNetWork{
    
    // 启动网络检测
    AFNetworkReachabilityManager *networkManager = [AFNetworkReachabilityManager sharedManager];
    [networkManager startMonitoring];
    [networkManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        // 当网络恢复的时候调用runtime配置接口，并通知到整个app；网络断开的时候发出提示，并通知到整个app
        if (status == AFNetworkReachabilityStatusReachableViaWWAN || status == AFNetworkReachabilityStatusReachableViaWiFi) {
        }
        else {
            
            //            [MBProgressHUD showError:@"断开连接"];
        }
    }];
}


- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [UMSocialSnsService handleOpenURL:url];
}
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return  [UMSocialSnsService handleOpenURL:url];
}

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [APService setBadge:0];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [APService registerDeviceToken:deviceToken];
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    
    [APService setBadge:0];
    [UIApplication sharedApplication].applicationIconBadgeNumber =0;
    NSLog(@"userInfo == %@",userInfo);
    if (application.applicationState == UIApplicationStateActive) {
        //转换成一个本地通知，显示到通知栏，你也可以直接显示出一个alertView，只是那样稍显aggressive：）
        UILocalNotification *localNotification = [[UILocalNotification alloc] init];
        localNotification.userInfo = userInfo;
        localNotification.soundName = UILocalNotificationDefaultSoundName;
        localNotification.alertBody = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
        localNotification.fireDate = [NSDate date];
        
        NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
        [def setObject:@"开" forKey:@"vision"];
        [def synchronize];
        
        //       [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
        [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 100)];
        view.backgroundColor = [UIColor blackColor];
        view.alpha = 0.8;
        
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width / 2 - 50, 19, 20, 20)];
        image.image = [UIImage imageNamed:@"icon"];
        [view addSubview:image];
        
        UILabel *labelName = [[UILabel alloc] initWithFrame:CGRectMake(0, 19, [[UIScreen mainScreen] bounds].size.width, 20)];
        labelName.textColor = [UIColor whiteColor];
        labelName.textAlignment = NSTextAlignmentCenter;
        labelName.text = @"汇客通";
        [view addSubview:labelName];
        
        UILabel *labelContent = [[UILabel alloc] initWithFrame:CGRectMake(50, 45, [[UIScreen mainScreen] bounds].size.width - 70, 40)];
        labelContent.numberOfLines = 0;
        labelContent.textColor = [UIColor whiteColor];
        labelContent.text = localNotification.alertBody;
        [view addSubview:labelContent];
        
        
        CGSize detailSize = [localNotification.alertBody sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake([[UIScreen mainScreen] bounds].size.width - 50, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping];
        labelContent.frame = CGRectMake(50, 45, [[UIScreen mainScreen] bounds].size.width - 70, detailSize.height);
        view.frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, detailSize.height+45);
        
        [UIView animateWithDuration:2
                         animations:^{
                             
                             view.frame = CGRectMake(0 , -detailSize.height-45, [[UIScreen mainScreen] bounds].size.width, detailSize.height+45);
                             
                         }];
        
        [self.window addSubview:view];
        
    }else{
        NSString *Pagename = userInfo[@"source"];
        
        NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
        [def setObject:@"开" forKey:@"vision"];
        [def synchronize];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"changePage" object:Pagename];
    }
}



-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    application.applicationIconBadgeNumber = 0;
    [application setApplicationIconBadgeNumber:0];
    [UIApplication sharedApplication].applicationIconBadgeNumber =0;
}


- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    if ([[[UIDevice currentDevice] systemVersion]floatValue]>=8.0) {
        
        if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]){
            //注册类型 警告框 红色的徽标 声音
            [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
        }
        
    }
    
    UILocalNotification*local=[[UILocalNotification alloc]init];
    //设置提醒内容
    local.alertBody=@"亲~你已经很长时间没使用汇客通了";
    //设置时间
    local.fireDate=[NSDate dateWithTimeIntervalSinceNow:604800];
    //设置提醒声音 支持30秒以内的声音,这个声音需要测试一下才可以使用，而且这个声音是本地必须有的
    local.soundName=UILocalNotificationDefaultSoundName;
    //设置徽标
    local.applicationIconBadgeNumber=1;
    //    当程序从后台进入前台的时候，在appdelegate中运行下面的方法，让徽标归0
    [UIApplication sharedApplication].applicationIconBadgeNumber=0;
    
    //    设置userinfo 方便在之后需要撤销的时候使用
    NSDictionary *info = [NSDictionary dictionaryWithObject:@"name"forKey:@"key"];
    local.userInfo = info;
    //加入到推送中
    [[UIApplication sharedApplication] scheduleLocalNotification:local];
    
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {

    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [APService setBadge:0];
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    NSArray*allLocalArray=[[UIApplication sharedApplication] scheduledLocalNotifications];
    
    for (int j=0; j<allLocalArray.count; j++) {
        UILocalNotification*not=allLocalArray[j];
        if ([not.alertBody hasPrefix:@"亲~你已"]) {
            //取消单个推送
            [[UIApplication sharedApplication] cancelLocalNotification:not];
        }
    }
}

- (void)applicationWillTerminate:(UIApplication *)application {
    //    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    
}






@end
