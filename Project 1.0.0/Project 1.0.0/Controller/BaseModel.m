//
//  BaseModel.m
//  Project 1.0.0
//
//  Created by lanou3g on 15/7/15.
//  Copyright (c) 2015年 teamwork. All rights reserved.
//

#import "BaseModel.h"

@implementation BaseModel

-(void)dealloc{
    [_mId release];
    [_images release];
    [_title release];
    [super dealloc];
}
@end
