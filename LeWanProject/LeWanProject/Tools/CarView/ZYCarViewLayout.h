//
//  ZYCarViewLayout.h
//  ZYCarView
//
//  Created by liqiaona on 2018/3/8.
//  Copyright © 2018年 ZY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZYCarViewLayout : UICollectionViewFlowLayout
@property (nonatomic) CGSize itemSize;
@property (nonatomic) NSInteger visibleCount;
@property (nonatomic) UICollectionViewScrollDirection scrollDirection;
@end
