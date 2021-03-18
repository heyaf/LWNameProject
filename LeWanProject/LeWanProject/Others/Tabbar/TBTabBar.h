//
//  TBTabBar.h
//  TabbarBeyondClick
//
//  Created by 卢家浩 on 2017/4/17.
//  Copyright © 2017年 lujh. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface TBTabBar : UITabBar

//@property(nonatomic,strong)UIButton *publishBtn;

@property (nonatomic,copy) void(^didClickPublishBtn)(void);
@property (nonatomic,assign) BOOL hasAddBtn; //是否有发布按钮
@end
