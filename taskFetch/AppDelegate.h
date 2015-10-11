//
//  AppDelegate.h
//  taskFetch
//
//  Created by 张鸿 on 15/10/1.
//  Copyright © 2015年 james.exericse.ios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property BOOL oneTimeConsumer;
@property NSString *content;
@property NSMutableData *receiveData;

- (void)parseAPNSContent : (NSDictionary *) userInfo;

@end

