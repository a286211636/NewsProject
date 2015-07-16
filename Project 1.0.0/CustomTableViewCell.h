//
//  CustomTableViewCell.h
//  Project 1.0.0
//
//  Created by lanou3g on 15/7/3.
//  Copyright (c) 2015年 teamwork. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BaseModel;
@interface CustomTableViewCell : UITableViewCell
@property (nonatomic,retain) BaseModel *model;
@end
