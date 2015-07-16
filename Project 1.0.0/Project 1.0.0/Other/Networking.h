//
//  Networking.h
//  UI lesson 18  封装与异步加载image
//
//  Created by lanou3g on 15/6/16.
//  Copyright (c) 2015年 lanou3g. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^Block)(id object);
@interface Networking : NSObject

//声明数据请求方法,将POST和Get请求写进一个方法里面，判断method(请求类型)
+(void)recivedDataWithURLString:(NSString*)urlString method:(NSString*)method body:(NSString*)body  block:(Block)block;
@end
