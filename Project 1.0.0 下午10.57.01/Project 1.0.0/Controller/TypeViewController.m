//
//  NextViewController.m
//  Project 1.0.0
//
//  Created by lanou3g on 15/7/1.
//  Copyright (c) 2015年 teamwork. All rights reserved.
//

#import "TypeViewController.h"
#import "TextTableViewCell.h"
#import "PrefixHeader.pch"
#import "DetailCellModel.h"
#import "DetailModel.h"
#import "ImageTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "Networking.h"

@interface NextViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) NSMutableArray *mutableArray;
@property (nonatomic, retain) NSMutableArray *detailArray;

@end


@implementation NextViewController

- (void)dealloc
{
    [_detailArray release];
    [_mutableArray release];
    [_tableView release];
    [_urlStr release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadingData];
    [self loadingTableView];
    
}



- (void)loadingData{
    
        self.mutableArray = [NSMutableArray array];
        self.detailArray = [NSMutableArray array];
    
        [Networking recivedDataWithURLString:self.urlStr method:@"GET" body:nil block:^(id object) {
        NSDictionary *dic = (NSDictionary *)object;
        DetailModel *model = [[DetailModel alloc]init];
        model.name = dic[@"name"];
        model.background = dic[@"background"];
            
    [[NSNotificationCenter defaultCenter]postNotificationName:@"url"object:nil userInfo:@{@"abc":model.background}];
            
        model.color = dic[@"color"];
        model.descriptio = dic[@"description"];
        [self.mutableArray addObject:model];
      
            
        for (NSDictionary *dictionary in dic[@"stories"]) {
            DetailCellModel *modelCell = [[DetailCellModel alloc]init];
            modelCell.mID = dictionary[@"id"];
            modelCell.images = [dictionary[@"images"] firstObject];
            
            modelCell.title = dictionary[@"title"];
            modelCell.type = dictionary[@"type"];
            [self.detailArray addObject:modelCell];
        }
        [self.tableView reloadData];
    }];
    
}

- (void)loadingTableView{
 
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[CustomTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.tableView registerClass:[TextTableViewCell class] forCellReuseIdentifier:@"CELL2"];

    self.view.backgroundColor = [UIColor whiteColor];
    
       [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(nimama:) name:@"url" object:nil];
   
    [self.view addSubview:self.tableView];
    [self.tableView release];
    
}
- (void)nimama:(NSNotification *)notification{
    
   NSString *string = [notification.userInfo objectForKey:@"abc"];

    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight / 3 - 25 )];
    

    [imageView sd_setImageWithURL:[NSURL URLWithString:string]];
    self.tableView.tableHeaderView = imageView;

    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.detailArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DetailCellModel *model = self.detailArray[indexPath.row];
    
    if (model.images.length == 0) {
        
    TextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL2" forIndexPath:indexPath];
    cell.model = model;
        return cell;
        
    } else {
        
    CustomTableViewCell *aCell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    aCell.txtLabel.text = model.title;
        [aCell.PicImg sd_setImageWithURL:[NSURL URLWithString:model.images]];
        
        return aCell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DetailCellModel *model = self.detailArray[indexPath.row];
    if (model.images == 0) {
        return 80;
    } else {
        return 90;
    }
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    
    
    
    
    
    
}


@end
