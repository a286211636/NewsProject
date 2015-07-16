//
//  CustomTableViewCell.m
//  Project 1.0.0
//
//  Created by lanou3g on 15/7/3.
//  Copyright (c) 2015年 teamwork. All rights reserved.
//

#import "CustomTableViewCell.h"
#import "PrefixHeader.pch"

@interface CustomTableViewCell ()

@property (nonatomic,retain) UIImageView *whiteImg;

@end
@implementation CustomTableViewCell

-(void)dealloc{
    [_txtLabel release];
    [_PicImg release];
    [_whiteImg release];
    [super dealloc];
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = kClolor(213,213 , 213, .3);

        _whiteImg = [[UIImageView alloc]init];
        _whiteImg.image = [UIImage imageNamed:@"holderImge"];
        [self.contentView addSubview:self.whiteImg];
        [_whiteImg release];

        _txtLabel = [[UILabel alloc]init];
        _txtLabel.text = @"安康和卡号的加大了激烈的就安静了捡垃圾A记录婕拉安多拉卡卡卡卡阿卡卡啦啦啦卡卡卡卡";
        _txtLabel.textAlignment = NSTextAlignmentLeft;
        _txtLabel.font =  k_boldFont(15);
        _txtLabel.numberOfLines = 0 ;
        [_whiteImg addSubview:_txtLabel];
        [_txtLabel release];
        
        _PicImg = [[UIImageView alloc]init];
        _PicImg.backgroundColor = [UIColor redColor];
        _PicImg.image = [UIImage imageNamed:@"bar.jpg"];
        [_whiteImg addSubview:_PicImg];
        [_PicImg release];
        
        
    }
    return self;
}

-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    _whiteImg.frame = CGRectMake(5, 10,k_frameWidth -10 , k_frameHeight - 10);
    
    _txtLabel.frame = CGRectMake(10, 0, k_frameWidth/3*2, k_frameHeight - 20);
    
    _PicImg.frame = CGRectMake(k_frameWidth/5*4-10,10,60, 60);
    
    
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
