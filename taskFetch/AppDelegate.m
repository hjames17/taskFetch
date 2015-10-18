//
//  AppDelegate.m
//  taskFetch
//
//  Created by 张鸿 on 15/10/1.
//  Copyright © 2015年 james.exericse.ios. All rights reserved.
//

#import "AppDelegate.h"
#import "APService.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //+jpush code start
    // Required
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [APService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                       UIUserNotificationTypeSound |
                                                       UIUserNotificationTypeAlert)
                                           categories:nil];
    } else {
        //categories 必须为nil
        [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                       UIRemoteNotificationTypeSound |
                                                       UIRemoteNotificationTypeAlert)
                                           categories:nil];
    }
    
    // Required
    [APService setupWithOption:launchOptions];
    [APService setAlias:@"first" callbackSelector:nil object:nil];
    //-jpush code end
    
    _controller = (ViewController*)_window.rootViewController;
    
    NSLog(@"numberOfRowsInSection is %li", [_controller tableView:_controller.tableView numberOfRowsInSection:0] );
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    //太土了，必须要先设一个角标值，再设回0,才能把通知去掉。。。。
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 1];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 0];
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    if(_oneTimeConsumer){
        
        [_controller.data removeAllObjects];
        [_controller.data addObject:_content];
        [_controller.tableView reloadData];
    }else{
        [self getLastedTaskUpdateInformation];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    // Required
    [APService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    [self parseAPNSContent:userInfo];
       // Required
    [APService handleRemoteNotification:userInfo];
    
    _oneTimeConsumer = true;
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    [self parseAPNSContent:userInfo];
    // IOS 7 Support Required
    [APService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
    
    _oneTimeConsumer = true;
}

- (void)parseAPNSContent : (NSDictionary *) userInfo{
    // 取得 APNs 标准信息内容
    NSDictionary *aps = [userInfo valueForKey:@"aps"];
    _content = [aps valueForKey:@"alert"]; //推送显示的内容
    NSInteger badge = [[aps valueForKey:@"badge"] integerValue]; //badge数量
    NSString *sound = [aps valueForKey:@"sound"]; //播放的声音
    
    // 取得自定义字段内容
    NSString *customizeField1 = [userInfo valueForKey:@"customizeField1"]; //自定义参数，key是自己定义的
    NSLog(@"content =[%@], badge=[%d], sound=[%@], customize field  =[%@]",_content,badge,sound,customizeField1);
    

}

- (void) getLastedTaskUpdateInformation{
    // create url
    NSURL * url = [NSURL URLWithString:@"http://115.29.203.145:8080/taskFetch/last"];
    // create http request
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    
    // send request
    [[NSURLConnection alloc]initWithRequest:request delegate:self];
    
}

//接收到服务器回应的时候调用此方法
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSHTTPURLResponse *res = (NSHTTPURLResponse *)response;
    NSLog(@"%@",[res allHeaderFields]);
    self.receiveData = [NSMutableData data];
    
}

//接收到服务器传输数据的时候调用，此方法根据数据大小执行若干次
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.receiveData appendData:data];
}

//数据传完之后调用此方法
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString *receiveStr = [[NSString alloc]initWithData:self.receiveData encoding:NSUTF8StringEncoding];
    NSLog(@"%@",receiveStr);
    [self showLatestUpdatedInformation];
}

//网络请求过程中，出现任何错误（断网，连接超时等）会进入此方法
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"%@",[error localizedDescription]);
}

-(void) showLatestUpdatedInformation{
    
    
    
    NSError *error = [NSError alloc];
    
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:self.receiveData options:NSJSONReadingMutableLeaves error:&error];
    
    [_controller.data removeAllObjects];
    
    for(NSDictionary *node in jsonArray){

        //从ISODate时间字符串中格式化出时间
        //源格式: yyyy-MM-ddThh:mm:ss.[123]oz
        //目标格式: yyyy-MM-dd/hh:mm:ss
        NSArray *updateTimes = [node valueForKey:@"updateTimes"];
        NSString *updateTime = [updateTimes lastObject];
        NSArray *parts = [updateTime componentsSeparatedByString:@"T"];
        NSArray *hmsParts = [[parts objectAtIndex:1] componentsSeparatedByString:@"."];
        NSArray *hms = [hmsParts firstObject];
        
//        NSString *time = [NSString stringWithFormat:@"%@/%@", [parts firstObject], [hmsParts firstObject]];
        NSString *time = [NSString stringWithFormat:@"%@", [hmsParts firstObject]];
        [_controller.data addObject:[NSDictionary dictionaryWithObjectsAndKeys:[node valueForKey:@"name"], @"name", time, @"time", nil]];

    }
    [_controller.tableView reloadData];
    
    
}



@end
