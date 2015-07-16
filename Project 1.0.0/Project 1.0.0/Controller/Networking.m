//
//  Networking.m
//  UI lesson 18  封装与异步加载image
//
//  Created by lanou3g on 15/6/16.
//  Copyright (c) 2015年 lanou3g. All rights reserved.
//

#import "Networking.h"

@implementation Networking

+(void)recivedDataWithURLString:(NSString*)urlString method:(NSString*)method body:(NSString*)body  block:(Block)block{
    //转换成URL
NSURL*url = [NSURL URLWithString:urlString];
    //准备请求  （request）
NSMutableURLRequest*request = [ NSMutableURLRequest requestWithURL:url];
    //设置请求方式
    [request setHTTPMethod:method];
    //判断，请求方式（Method传进来的值为判断依据）
    if ([method isEqualToString:@"POST"]) {
        NSData*data = [body dataUsingEncoding:NSUTF8StringEncoding];
        [request setHTTPBody:data];
        
    }
    //链接
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        id tempObj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        //使用block将此对象传回到视图控制器
        block(tempObj);
    }];



}

@end
