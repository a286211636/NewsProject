//
//  ModelTool.h
//  Project 1.0.0
//
//  Created by lanou3g on 15/7/16.
//  Copyright (c) 2015年 teamwork. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^Myblock)(NSMutableArray *);

@class WheelModel;
@class BaseModel;
@interface ModelTool : NSObject
@property (nonatomic,retain)NSMutableArray *baseArray;//cell数据原数组
@property (nonatomic,retain)NSMutableArray *wheelArray;
-(void)loadData:(Myblock)block;
-(NSInteger)wheelModelCount;
-(NSInteger)baseModelCount;
-(BaseModel*)modelWithIndex:(NSInteger)index;
+(ModelTool*)shareManager;
-(WheelModel*)wheelArrayWithindex:(NSInteger)index;
@end
