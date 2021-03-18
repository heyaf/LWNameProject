//
//  LZHHeaderView.h
//  LZH_PersonalCenter
//
//  Created by admin  on 2018/7/21.
//  Copyright © 2018年 刘中华. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LZHHeaderView : UIView

+(instancetype)intHeaderView ;

@property (weak, nonatomic) IBOutlet UIImageView *headerImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@end
