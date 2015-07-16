 //
//  ModelTool.m
//  Project 1.0.0
//
//  Created by lanou3g on 15/7/16.
//  Copyright (c) 2015年 teamwork. All rights reserved.
//

#import "ModelTool.h"
#import "WheelModel.h"
#import "BaseModel.h"
#import "Networking.h"

#define URLStr @"http://news-at.zhihu.com/api/4/stories/latest"


@interface ModelTool()



@end

@implementation ModelTool

-(void)loadData:(Myblock)block {
    
    __block typeof(self)aSelf = self;
    
    self.baseArray = [NSMutableArray array];
    
    self.wheelArray = [NSMutableArray array];
    
    
    [Networking recivedDataWithURLString:URLStr method:@"GET" body:nil block:^(id object) {
        
        NSDictionary *dic = (NSDictionary*)object;
        
        NSArray *array = dic[@"stories"];
        
        for (NSDictionary *tempDic in array) {
            
            BaseModel *aModel = [[BaseModel alloc]init];
            
            aModel.images =  [tempDic[@"images"]firstObject];
            
            aModel.title = tempDic[@"title"];
            
            aModel.mId = tempDic[@"id"];
            
            [aSelf.baseArray addObject:aModel];
            //block (self.baseArray);
            
        }
        NSArray *arr = dic[@"top_stories"];
        
        for (NSDictionary *ADic in arr) {
            
            WheelModel *model = [[WheelModel alloc]init];
            
            model.img = ADic[@"image"];
            
            model.title = ADic[@"title"];
            
            model.mId = ADic[@"id"];
            
            [aSelf.wheelArray addObject:model];
            
            block(self.wheelArray);
        }
        
    }];

}

+(WheelModel *)shareManager{
    
    static WheelModel *WheelModelShareManager = nil;
    static dispatch_once_t oneToken;
    dispatch_once(&oneToken, ^{
        
        WheelModelShareManager = [[self alloc]init];
    });
    return WheelModelShareManager;
}

-(NSInteger)baseModelCount{
    return self.baseArray.count;
}
-(NSInteger)wheelModelCount{
    
    return self.wheelArray.count;
   
}


-(BaseModel *)modelWithIndex:(NSInteger)index{
    return self.baseArray[index];
}

-(WheelModel*)wheelArrayWithindex:(NSInteger)index{
    return self.wheelArray[index];
}










@end
