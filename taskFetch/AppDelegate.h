//
//  AppDelegate.h
//  taskFetch
//
//  Created by 张鸿 on 15/10/1.
//  Copyright © 2015年 james.exericse.ios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataSource.h"
#import "ViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, UITableViewDataSource>

@property (strong, nonatomic) UIWindow *window;
@property ViewController *controller;

@property BOOL oneTimeConsumer;
@property NSString *content;
@property NSMutableData *receiveData;

- (void)parseAPNSContent : (NSDictionary *) userInfo;

@end

