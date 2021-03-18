//
//  ZYCarView.h
//  ZYCarView
//
//  Created by liqiaona on 2018/3/8.
//  Copyright © 2018年 ZY. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ClickBlock)(NSString *name);
@interface ZYCarView : UIView
@property(nonatomic,strong)NSMutableArray *array;
@property (nonatomic,copy) ClickBlock block;
-(void)setArrayData:(NSArray *)array superScrollView:(UIScrollView *)superScrollView;
-(void)setArraypinyin:(NSArray *)PYarray name:(NSArray *)nameArr wuxing:(NSArray *)wuxingArr superScrollView:(UIScrollView *)superScrollView;

@end
