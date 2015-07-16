//
//  TextTableViewCell.m
//  Project 1.0.0
//
//  Created by lanou3g on 15/7/15.
//  Copyright (c) 2015年 teamwork. All rights reserved.
//

#import "TextTableViewCell.h"
#import "PrefixHeader.pch"
@interface TextTableViewCell()
@property (nonatomic,retain) UIImageView *whiteImg;
@property (nonatomic,retain) UILabel *txtLabel;
@end

@implementation TextTableViewCell
-(void)dealloc{
    [_whiteImg release];
    [_txtLabel release];
    [super dealloc];
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.contentView.backgroundColor = kClolor(213,213,213,0.3);
;
        _whiteImg = [[UIImageView alloc]init];
        _whiteImg.image = [UIImage imageNamed:@"holderImge"];
        [self.contentView addSubview:_whiteImg];
        [_whiteImg release];
        
        _txtLabel = [[UILabel alloc]init];
        _txtLabel.text = @"露露露露了来人了了人类历史老师浪费";
        _txtLabel.textAlignment = NSTextAlignmentLeft;
        _txtLabel.font =  k_boldFont(15);
        _txtLabel.numberOfLines = 0 ;
        [_whiteImg addSubview:_txtLabel];
        [_txtLabel release];
        
        
        
    }
    return self;
    
}
-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    _whiteImg.frame = CGRectMake(5, 10,k_frameWidth -10 , k_frameHeight - 10);
    
    _txtLabel.frame = CGRectMake(10, 0, k_frameWidth/3*2, k_frameHeight - 20);
    
}

- (void)setModel:(DetailCellModel *)model{
    if (_model != model) {
        [_model release];
        _model = [model retain];
        
        _txtLabel.text = model.title; 
    }
    
}


@end
