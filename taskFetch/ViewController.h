//
//  ViewController.h
//  taskFetch
//
//  Created by 张鸿 on 15/10/1.
//  Copyright © 2015年 james.exericse.ios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property NSMutableArray *data;

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;

@end

