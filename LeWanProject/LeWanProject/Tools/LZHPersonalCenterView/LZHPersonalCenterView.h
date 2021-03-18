//
//  LZHPersonalCenterView.h
//  LZH_PersonalCenter
//
//  Created by admin  on 2018/7/21.
//  Copyright © 2018年 刘中华. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LZHPersonalCenterViewDelegate <NSObject>

//点击cell事件
-(void)didSelectRowTitle:(NSString *)title;
//点击头部事件
-(void)tapHeader;
@end

@interface LZHPersonalCenterView : UIView

/**
 参数二：内容数组
 参数三：是否显示头部 YES：显示 ，NO：不显示
 */
-(instancetype)initWithFrame:(CGRect)frame CenterArr:(NSArray *)CenterArr isShowHeader:(BOOL)isShowHeader;

@property(nonatomic,assign)id<LZHPersonalCenterViewDelegate>delegate ;

//扩展内容数组
@property(nonatomic,strong)NSArray * extendCenterRightArr ;

@end
