//
//  LZHPersonalCenterCell.h
//  LZH_PersonalCenter
//
//  Created by admin  on 2018/7/21.
//  Copyright © 2018年 刘中华. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LZHPersonalCenterCell : UITableViewCell

@property(nonatomic,strong)UIView * bottomLinkView ;
@property(nonatomic,assign)NSString * bottomLinkLong ;
@property(nonatomic,strong)UIImageView * leftImg ;
@property(nonatomic,strong)UILabel * titleLabel ;
@property(nonatomic,strong)UIImageView * rightImg ;
@property(nonatomic,strong)UILabel * rightExtendLabel ;

//标题/图标
@property(nonatomic,strong)NSString * centerNS ;
//扩展内容
@property(nonatomic,strong)NSString * extendCenterRightNS ;
@end
