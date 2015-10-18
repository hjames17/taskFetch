//
//  DataSource.m
//  taskFetch
//
//  Created by 张鸿 on 15/10/11.
//  Copyright © 2015年 james.exericse.ios. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataSource.h"

@implementation DataSource

/*
 没有用
 */


-(void) setData:(NSArray *)data{
    _data = data;
}

-(NSArray*) getData{
    return _data;
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
    cell.detailTextLabel.text = [_data objectAtIndex:indexPath.row];
    
    // 3.选中效果 一共有4种效果，貌似蓝色的不管用了,default 也是gray的。。。
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    
    
    cell.textLabel.text =  [_data objectAtIndex:indexPath.row];
    return cell;
}

#pragma mark - accessory 点击事件代理
-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
}

#pragma mark - cell点击事件代理 选中了那行
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}



//#pragma mar - 设置右边的索引条
//- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
//{
//    // 超出个数的那些东东他不会相应
//    return [NSArray arrayWithObjects:@"A",@"B", @"C", @"D",@"E", nil];
//}

#pragma mark - 设置secion头部标题
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"";
}

#pragma mark - 设置section的尾部
-(NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    return @"";
}

//#pragma mark   - 设置行高
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 40;
//}

//#pragma mark -设置缩进级别
//-(NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (indexPath.row %2) {
//        return 2;
//    }
//    
//    return 5;
//}




@end

