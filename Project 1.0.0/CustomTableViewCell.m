//
//  CustomTableViewCell.m
//  Project 1.0.0
//
//  Created by lanou3g on 15/7/3.
//  Copyright (c) 2015年 teamwork. All rights reserved.
//

#import "CustomTableViewCell.h"
#import "PrefixHeader.pch"
#import "BaseModel.h"
#import  "UIImageView+WebCache.h"

@interface CustomTableViewCell ()
@property (nonatomic ,retain) UILabel *txtLabel;
@property (nonatomic,retain) UIImageView *PicImg;
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
        
        _whiteImg = [[UIImageView alloc]init];
        _whiteImg.image = [UIImage imageNamed:@"holderImge"];
        [self.contentView addSubview:_whiteImg];
        [_whiteImg release];

        _txtLabel = [[UILabel alloc]init];

        _txtLabel.textAlignment = NSTextAlignmentLeft;
        _txtLabel.font =  k_boldFont(15);
        _txtLabel.numberOfLines = 0 ;
        [_whiteImg addSubview:_txtLabel];
        [_txtLabel release];
        
        _PicImg = [[UIImageView alloc]init];
        _PicImg.backgroundColor = [UIColor redColor];
        [_whiteImg addSubview:_PicImg];
        [_PicImg release];
        
        
    }
    return self;
}
-(void)setModel:(BaseModel *)model{
    if (_model != model) {
        [_model release];
        _model = [model retain];
    }
    _txtLabel.text = model.title;
    [_PicImg sd_setImageWithURL:[NSURL URLWithString:model.images]];
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
