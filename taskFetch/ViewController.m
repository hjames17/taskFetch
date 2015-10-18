//
//  ViewController.m
//  taskFetch
//
//  Created by 张鸿 on 15/10/1.
//  Copyright © 2015年 james.exericse.ios. All rights reserved.
//

#import "ViewController.h"
#import "DataSource.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _data = [[NSMutableArray alloc]init];
    _tableView.dataSource = self;
    NSLog(@"view did load");

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    //UITableViewCellStyle一共有4中
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    // 1. 自定义cellImage
    //    cell.imageView.image  = [UIImage imageNamed:@"cellImage.png"];
    
    // 2. 设置detailLable
    cell.detailTextLabel.text = [NSString stringWithFormat:@"更新时间:%@", [[_data objectAtIndex:indexPath.row]valueForKey:@"time"]];
    
    // 3.选中效果 一共有4种效果，貌似蓝色的不管用了,default 也是gray的。。。
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    
    
    cell.textLabel.text =  [[_data objectAtIndex:indexPath.row]valueForKey:@"name"];
    return cell;
}

@end
