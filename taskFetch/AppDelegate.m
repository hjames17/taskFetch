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
    
    UIView *root =[[_window subviews] firstObject];
    UIView *view = [[root subviews] firstObject];
    NSLog(@"number of subviews before added is %lu", [[view subviews] count]);
    if(_oneTimeConsumer){
        NSArray<__kindof UIView*> *views = [view subviews];
        for(UIView *cell in views){
            [cell removeFromSuperview];
            //should release?
        }
        
        //show notification
        
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        
        cell.textLabel.text = _content;
        
        [view addSubview:cell];
        _oneTimeConsumer = false;
        _content = nil;
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
//    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:0];
    
    // send request
    NSURLConnection *connection = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    
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
    
    
    UIView *root =[[_window subviews] firstObject];
    UIView *view = [[root subviews] firstObject];
    NSLog(@"number of subviews before added is %lu", [[view subviews] count]);
    NSArray<__kindof UIView*> *views = [view subviews];
    for(UIView *cell in views){
        [cell removeFromSuperview];
        //should release?
    }
    
    
    for(NSDictionary *node in jsonArray){
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        
        NSString *updateTime = [node valueForKey:@"updateTime"];
        NSArray *parts = [updateTime componentsSeparatedByString:@"T"];
        NSArray *hmsParts = [[parts objectAtIndex:1] componentsSeparatedByString:@"."];
        NSArray *hms = [hmsParts firstObject];
        cell.textLabel.text = [NSString stringWithFormat:@"%@%@,%@更新", [node valueForKey:@"name" ], hms, [parts firstObject]];
        
        [view addSubview:cell];
    }

    
    
    
    
//    UITableViewCell *cell1 = [[UITableViewCell alloc] init];
//    
//    cell1.textLabel.text = @"test2";
//    
//    cell1.frame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y + cell.frame.size.height, cell.frame.size.width, cell.frame.size.height);
//    
//    [view insertSubview:cell1 belowSubview:cell];
//    
//    NSLog(@"number of subviews is %lu", [[view subviews] count]);
}
@end
