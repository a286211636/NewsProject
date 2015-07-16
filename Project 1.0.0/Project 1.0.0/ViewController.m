//
//  ViewController.m
//  Project 1.0.0
//
//  Created by lanou3g on 15/7/1.
//  Copyright (c) 2015年 teamwork. All rights reserved.
//

#import "ViewController.h"
#import "DOPNavbarMenu.h"
#import "TypeViewController.h"
#import "PrefixHeader.pch"
#import "CustomTableViewCell.h"
#import "UIImageView+WebCache.h"




@interface ViewController () <UITextViewDelegate, DOPNavbarMenuDelegate,UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
@property(assign,nonatomic) NSInteger numberOfItemsInRow;//设置每行item个数
@property(retain,nonatomic)DOPNavbarMenu *menu; // 声明属性
@property(nonatomic,retain)NSArray *titleArray; //存放 标题
@property(nonatomic,retain)NSMutableArray *itemArray;//存放 item
@property(nonatomic,retain)NSTimer *timer;//声明一个timer
@property(nonatomic,retain)UITableView *tableView;//tableView
@property(nonatomic,retain)UIScrollView *scroView;//放轮播图的scrollView
@property(nonatomic,retain)UIImageView *wheelImageView;//轮播图片
@property(nonatomic,retain)NSArray *picUrlArray;//图片Url数组
@property(nonatomic,retain)UIPageControl *pageControl;//翻页控制
@property(nonatomic,assign)NSInteger integer; //表示图片的下标


@end

@implementation ViewController
-(void)dealloc{
    [_menu release];
    [_titleArray release];
    [_itemArray release];
    [_tableView release];
    [_scroView release];
    [_wheelImageView release];
    [_timer release];
    [_picUrlArray release];
    [_pageControl release];
    [super dealloc];
}
#pragma mark === 配置菜单
- (DOPNavbarMenu *)menu {
    if (_menu == nil) {
        
        _titleArray = @[@"情感世界",@"体育部落",@"科技前沿",@"影视资讯",@"游戏热评",@"音乐地带"];
        _itemArray = [[NSMutableArray alloc]init];
        
        for (int i = 0; i  < 6; i++) {
            DOPNavbarMenuItem *item = [[DOPNavbarMenuItem ItemWithTitle:_titleArray[i] icon:[UIImage imageNamed:[NSString stringWithFormat:@"%d",i+1]]]autorelease];
            [_itemArray addObject:item];
            _menu = [[DOPNavbarMenu alloc] initWithItems:_itemArray  width:self.view.dop_width maximumNumberInRow:_numberOfItemsInRow];
            _menu.separatarColor = [UIColor whiteColor];
            _menu.delegate = self;
         
        }
        
   }
    return _menu;
  
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavigation];
    [self setUpTableView];

}
//#pragma mark ===  状态栏设置

//- (UIStatusBarStyle)preferredStatusBarStyle {
//    return UIStatusBarStyleLightContent;
//}

#pragma mark ===  设置 UITableView
-(void)setUpTableView{
    
    
  //  _picUrlArray = [NSArray array];
    
    
    //在hearderView设置轮播图
    _scroView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight/3 -25)];
    _scroView.delegate = self;
#warning picUrlArray 为存放轮播图片的URL,暂时还没拿到值
    _scroView.contentSize = CGSizeMake(kScreenWidth *self.picUrlArray.count, 0);
    
    _scroView.pagingEnabled = YES;
    _scroView.showsHorizontalScrollIndicator = NO;
    
   
    for (int i = 0 ; i < self.picUrlArray.count; i++) {
        _wheelImageView = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth * i, 0, kScreenWidth ,kScreenHeight/3 -25)];
        [_wheelImageView sd_setImageWithURL:self.picUrlArray[i]];
        _wheelImageView.userInteractionEnabled = YES;
        [self.scroView addSubview:_wheelImageView];
        [_wheelImageView release];
        
    }
    
    _tableView = [[UITableView alloc]initWithFrame:kScreen style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 90;
    _tableView.separatorStyle = 0;
    
    [_tableView registerClass:[CustomTableViewCell class] forCellReuseIdentifier:@"cell"];
    
    _tableView.tableHeaderView = _scroView;
    [self.view addSubview:_tableView];
    

    
    _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake((kScreenWidth - 80)/2, self.scroView.frame.size.height - 20, 80, 10)];
    _pageControl.numberOfPages = self.picUrlArray.count;
   
    _pageControl.currentPage = 0;
    _pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    _pageControl.pageIndicatorTintColor = [UIColor grayColor];
    [_tableView addSubview:_pageControl];
    [_pageControl release];
    

    [self timerStart];
}


#pragma mark === tableView代理方法的实现
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.backgroundColor = kClolor(213,213,213,0.3);

    return cell;
}

#pragma mark === 设置timer
-(void)timerStart{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
    [self.timer fire];
}
-(void)timerStop{
    [self.timer invalidate];
}
-(void)timerAction:(NSTimer*)timer{
    self.integer = self.pageControl.currentPage;
    self.integer++;
    if (self.integer  >self.picUrlArray.count - 1) {
        self.integer = 0 ;
    }
        self.scroView.contentOffset = CGPointMake(self.integer * kScreenWidth, 0);
    
    self.pageControl.currentPage = self.scroView.contentOffset.x /kScreenWidth;
    
}

#pragma mark === scrollView代理方法的实现
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    _pageControl.currentPage = scrollView.contentOffset.x / kScreenWidth;
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self timerStop];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self timerStart];
}

#pragma mark === 设置 NavigationBar
-(void)setUpNavigation{
    self.title = @"首页";
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"bar.jpg"] forBarMetrics:UIBarMetricsDefault];
    
    self.numberOfItemsInRow = 3;
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"更多" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonAction:)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor blackColor];
    [self.navigationItem.rightBarButtonItem  release];
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 0, 60, 40);
    
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
      self.navigationItem.leftBarButtonItem = leftBarButton;
    
     self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"设置" style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonAction:)];
  
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor blackColor];
       
}
#pragma mark  视图即将消失方法实现
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.menu) {
        [self.menu dismissWithAnimation:NO];
    }
}
#pragma mark === right按钮点击方法的实现
- (void)rightBarButtonAction:(UIBarButtonItem*)sender {
    self.navigationItem.rightBarButtonItem.enabled = NO;
    if (self.menu.isOpen) {
        [self.menu dismissWithAnimation:YES];
    } else {
        [self.menu showInNavigationController:self.navigationController];
    }
}
#pragma mark === left按钮点击方法的实现
-(void)leftBarButtonAction:(UIBarButtonItem*)sender{

    
    }
#pragma mark ===  实现 DOPNavbarMenuDelegate 显示 方法
- (void)didShowMenu:(DOPNavbarMenu *)menu {
    [self.navigationItem.rightBarButtonItem setTitle:@"退出"];
    self.navigationItem.rightBarButtonItem.enabled = YES;
}
#pragma mark ===  实现 DOPNavbarMenuDelegate  消失 方法

- (void)didDismissMenu:(DOPNavbarMenu *)menu {
    [self.navigationItem.rightBarButtonItem setTitle:@"更多"];
    self.navigationItem.rightBarButtonItem.enabled = YES;
}
#pragma mark ===  实现 DOPNavbarMenuDelegate  选择 方法

- (void)didSelectedMenu:(DOPNavbarMenu *)menu atIndex:(NSInteger)index {
    
    NextViewController *nextVC = [[NextViewController alloc]init];
     NSString *urlStr = @"http://news-at.zhihu.com/api/4/theme/";
    
    switch (index) {
        case 0:
            urlStr = [urlStr stringByAppendingString:@"12"];
            break;
        case 1:
            urlStr = [urlStr stringByAppendingString:@"8"];
            break;
        case 2:
            urlStr = [urlStr stringByAppendingString:@"13"];
            break;
        case 3:
            urlStr = [urlStr stringByAppendingString:@"2"];
            break;
        case 4:
            urlStr = [urlStr stringByAppendingString:@"3"];
            break;
        case 5:
            urlStr = [urlStr stringByAppendingString:@"7"];
            break;

        default:
            break;
    }
    nextVC.urlStr = urlStr;
    [self.navigationController pushViewController:nextVC animated:YES];
}

#pragma mark ===  实现 UITextViewDelegate 方法
- (void)textViewDidChange:(UITextView *)textView {
    self.numberOfItemsInRow = [textView.text integerValue];
    self.menu = nil;
}
#pragma mark === 动画效果
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    self.menu = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
