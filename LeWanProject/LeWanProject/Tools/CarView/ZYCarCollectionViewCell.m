//
//  ZYCarCollectionViewCell.m
//  ZYCarView
//
//  Created by liqiaona on 2018/3/8.
//  Copyright © 2018年 ZY. All rights reserved.
//

#import "ZYCarCollectionViewCell.h"

@interface ZYCarCollectionViewCell()

@end
@implementation ZYCarCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.shadowRadius = 6.0f;
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOpacity = 6.0f;
    self.layer.shadowOffset = CGSizeMake(0, 0);
    self.layer.masksToBounds = NO;
    
    ViewBorderRadius(_jiexiLabel, 10.5, 1, KGrayColor);
    
}

-(void)setModel:(ZYCarModel *)model{
    _model = model;
   
    self.imageView.image = [UIImage imageNamed:model.imageUrl];
    self.label1.text = model.pinyinStr;
    self.label2.text = model.nameStr;
    self.label3.text = model.wuxingStr;
}
@end
