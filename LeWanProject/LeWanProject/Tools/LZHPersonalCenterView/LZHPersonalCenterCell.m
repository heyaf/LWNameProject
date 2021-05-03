//
//  LZHPersonalCenterCell.m
//  LZH_PersonalCenter
//
//  Created by admin  on 2018/7/21.
//  Copyright © 2018年 刘中华. All rights reserved.
//

#import "LZHPersonalCenterCell.h"

@implementation LZHPersonalCenterCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

       [self addSubview:self.bottomLinkView]; //底部线
       [self addSubview:self.leftImg];//左侧图标
       [self addSubview:self.titleLabel]; //标题文字
       [self addSubview:self.rightImg] ; //右侧箭头
       [self addSubview:self.rightExtendLabel]; //右侧扩展说明内容
    }
    return self;
}

//布局
-(void)layoutSubviews{
    [super layoutSubviews];
    
    if ([self.bottomLinkLong isEqualToString:@"Long"]) {
        self.bottomLinkView.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, 1) ;
    }else{
        self.bottomLinkView.frame = CGRectMake(15, self.frame.size.height-1, self.frame.size.width-15, 1) ;
    }

    self.leftImg.frame = CGRectMake(20, (self.frame.size.height-25)/2, 25, 25) ;
    self.titleLabel.frame = CGRectMake(55, 0, 150, self.frame.size.height) ;
    self.rightImg.frame = CGRectMake(self.frame.size.width-26, (self.frame.size.height-16)/2, 16, 16) ;
    self.rightExtendLabel.frame = CGRectMake(160, 0, self.frame.size.width-190, self.frame.size.height) ;
}

//附值
-(void)setCenterNS:(NSString *)centerNS{
    _centerNS = centerNS ;
    self.leftImg.image = [UIImage imageNamed:centerNS] ;
    self.titleLabel.text = centerNS ;
}

//设置最后一条底线全场
-(void)setBottomLinkLong:(NSString *)bottomLinkLong{
    _bottomLinkLong = bottomLinkLong ;
}

-(void)setExtendCenterRightNS:(NSString *)extendCenterRightNS{
    _extendCenterRightNS = extendCenterRightNS ;
    self.rightExtendLabel.text = extendCenterRightNS ;
}

#pragma mark--懒加载
-(UIView *)bottomLinkView{
    if (!_bottomLinkView) {
        _bottomLinkView = [[UIView alloc]initWithFrame:CGRectZero];
        _bottomLinkView.backgroundColor = [UIColor groupTableViewBackgroundColor] ;
    }
    return _bottomLinkView ;
}

-(UIImageView *)leftImg{
    if (!_leftImg) {
        _leftImg = [[UIImageView alloc]initWithFrame:CGRectZero];
    }
    return _leftImg ;
}

-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _titleLabel.font = [UIFont systemFontOfSize:16] ;
    }
    return _titleLabel ;
}

-(UIImageView *)rightImg{
    if (!_rightImg) {
        _rightImg = [[UIImageView alloc]initWithFrame:CGRectZero];
        _rightImg.image = [UIImage imageNamed:@"箭头向右"] ;
    }
    return _rightImg ;
}

-(UILabel *)rightExtendLabel{
    if (!_rightExtendLabel) {
        _rightExtendLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _rightExtendLabel.font = [UIFont systemFontOfSize:14] ;
        _rightExtendLabel.textColor = [UIColor orangeColor] ;
        _rightExtendLabel.textAlignment = 2 ;
    }
    return _rightExtendLabel ;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
