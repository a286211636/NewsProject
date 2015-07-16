//
//  ViewController.m
//  Project 1.0.0
//
//  Created by lanou3g on 15/7/1.
//  Copyright (c) 2015年 teamwork. All rights reserved.
//

#import "ViewController.h"
#import "DOPNavbarMenu.h"
#import "PrefixHeader.pch"
#import "CustomTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "ModelTool.h"
#import "WheelModel.h"



@interface ViewController () <UITextViewDelegate, DOPNavbarMenuDelegate,UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
@property(assign,nonatomic) NSInteger numberOfItemsInRow;//设置每行item个数
@property(retain,nonatomic)DOPNavbarMenu *menu; // 声明属性
@property(nonatomic,retain)NSArray *titleArray; //存放 标题
@property(nonatomic,retain)NSMutableArray *itemArray;//存放 item
@property(nonatomic,retain)NSTimer *timer;//声明一个timer
@property(nonatomic,retain)UITableView *tableView;//tableView
@property(nonatomic,retain)UIScrollView *scroView;//放轮播图的scrollView
@property(nonatomic,retain)UIImageView *wheelImageView;//轮播图片
@property(nonatomic,retain)UIPageControl *pageControl;//翻页控制
@property(nonatomic,assign)NSInteger integer; //表示图片的下标
@property(nonatomic,retain)UIImageView *backView; //抽屉视图
@property (nonatomic,retain)UILabel *label;//轮播图标题


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
    
    
    [_pageControl release];
    
    [_backView release];
    
    [_label release];
    
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
    
    
    [[ModelTool shareManager]loadData:^(NSMutableArray *array) {
        
        [self setUpTableView];
        [self.tableView reloadData];
    }];
    
    
   
    _backView = [[UIImageView alloc]initWithFrame:CGRectMake(-kScreenWidth, 64, kScreenWidth , kScreenHeight - 64)];
       [self.view addSubview:_backView];
    
    [_backView release];
 }

#pragma mark ===  设置 UITableView



-(void)setUpTableView{
    
    //在hearderView设置轮播图
    
    _scroView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight/3 -25)];
    
    _scroView.delegate = self;

    _scroView.contentSize = CGSizeMake(kScreenWidth * [[ModelTool shareManager]wheelModelCount] , 0);
  
      _scroView.pagingEnabled = YES;
    
    _scroView.showsHorizontalScrollIndicator = NO;
    
    
    for (int i = 0 ; i < [[ModelTool shareManager]wheelModelCount]; i++) {
        
        _wheelImageView = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth * i, 0, kScreenWidth ,kScreenHeight/3 -25)];
        NSURL *url = [NSURL URLWithString:[[ModelTool shareManager ] wheelArrayWithindex:i].img];
        
      
       [_wheelImageView sd_setImageWithURL:url];
       
        _wheelImageView.userInteractionEnabled = YES;
        [self.scroView addSubview:_wheelImageView];
        
        [_wheelImageView release];
        
        _label = [[UILabel alloc]initWithFrame:CGRectMake(20, self.scroView.frame.size.height - 60, kScreenHeight/2, 60)];
        _label.numberOfLines = 0;
        _label.font = k_boldFont(18);
        _label.textColor = [UIColor whiteColor];
        _label.textAlignment = NSTextAlignmentLeft;
        _label.text = [[ModelTool shareManager]wheelArrayWithindex:i].title;
        [_wheelImageView addSubview:_label];
        [_label release];
    
    }
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
    
    _tableView.delegate = self;
    
    _tableView.dataSource = self;
    
    _tableView.rowHeight = 90;
    
    _tableView.showsVerticalScrollIndicator = NO;
 
    _tableView.separatorStyle = 0;
    
    [_tableView registerClass:[CustomTableViewCell class] forCellReuseIdentifier:@"cell"];
    
    _tableView.tableHeaderView = _scroView;
    
   //[self.view addSubview:_tableView];
    

    
    _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(kScreenWidth /2, self.scroView.frame.size.height - 15, 10, 10)];
    
    _pageControl.numberOfPages = [[ModelTool shareManager]wheelModelCount];
   
    _pageControl.currentPage = 0;
    
    _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    
    _pageControl.pageIndicatorTintColor = [UIColor grayColor];
    
    [_tableView addSubview:_pageControl];
    
    [_pageControl release];
    

    [self timerStart];
  
}


#pragma mark === tableView代理方法的实现

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
   return [[ModelTool shareManager]baseModelCount];
  
   
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.backgroundColor = kClolor(213,213,213,0.3);
    
    cell.model = [[ModelTool shareManager]modelWithIndex:indexPath.row];

    
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
    
    if (self.integer  > self.pageControl.numberOfPages - 1) {
        
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
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"iconfont-shangla.png"]  style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonAction:)];
    
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    
    [self.navigationItem.rightBarButtonItem  release];
    
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    leftButton.frame = CGRectMake(0, 0, 40, 40);
    [leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"iconfont-shezhi(2).png"]  forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"iconfont-fanhui(1).png"]  forState:UIControlStateSelected];
    
    [leftButton addTarget:self action:@selector(leftButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
      UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
   
     self.navigationItem.leftBarButtonItem = leftBarButton;
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

-(void)leftButtonAction:(UIButton*)sender{
    if (sender.selected) {
         sender.selected = NO;
       [UIView animateWithDuration:0.3f animations:^{
           _backView.frame = CGRectMake(-kScreenWidth, 64, kScreenWidth , kScreenHeight - 64);
           _tableView.frame = CGRectMake(0, 64, kScreenWidth, kScreenHeight) ;
               }];
       
    }else{
        sender.selected = YES;
       [UIView animateWithDuration:0.3f animations:^{
           _backView.frame = CGRectMake(0, 64, kScreenWidth , kScreenHeight - 64);
           _backView.image = [UIImage imageNamed:@"back.jpg"];
           
           _tableView.frame = CGRectMake(kScreenWidth /4*3, 100, kScreenWidth/2, kScreenHeight/3*2 +40);
        
                [self.view addSubview:_tableView];
           
       }];
    }
    
}


#pragma mark ===  实现 DOPNavbarMenuDelegate 显示 方法

- (void)didShowMenu:(DOPNavbarMenu *)menu {
    
    [self.navigationItem.rightBarButtonItem setImage:[UIImage imageNamed:@"iconfont-shangla.png"]];
    
    self.navigationItem.rightBarButtonItem.enabled = YES;
}
#pragma mark ===  实现 DOPNavbarMenuDelegate  消失 方法

- (void)didDismissMenu:(DOPNavbarMenu *)menu {
    
    [self.navigationItem.rightBarButtonItem setImage:[UIImage imageNamed:@"iconfont-slide-updown.png"]];
    
    self.navigationItem.rightBarButtonItem.enabled = YES;
}
#pragma mark ===  实现 DOPNavbarMenuDelegate  选择 方法

- (void)didSelectedMenu:(DOPNavbarMenu *)menu atIndex:(NSInteger)index {
    
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
