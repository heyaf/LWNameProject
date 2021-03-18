//
//  ZYCarCollectionViewCell.h
//  ZYCarView
//
//  Created by liqiaona on 2018/3/8.
//  Copyright © 2018年 ZY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZYCarModel.h"
@interface ZYCarCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;

@property (weak, nonatomic) IBOutlet UILabel *jiexiLabel;
@property(nonatomic,strong)ZYCarModel *model;

@end
