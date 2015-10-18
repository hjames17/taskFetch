//
//  DataSource.h
//  taskFetch
//
//  Created by 张鸿 on 15/10/11.
//  Copyright © 2015年 james.exericse.ios. All rights reserved.
//

#ifndef DataSource_h
#define DataSource_h

#import <UIKit/UIKit.h>

@interface DataSource : NSObject<UITableViewDataSource>

@property NSMutableArray *data;

-(void) setData:(NSMutableArray *)data;

-(NSMutableArray*) getData;

@end

#endif /* DataSource_h */
