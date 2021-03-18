//
//  ZYCarModel.h
//  ZYCarView
//
//  Created by liqiaona on 2018/3/9.
//  Copyright © 2018年 ZY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZYCarModel : NSObject
@property (nonatomic, assign) NSInteger newsId;
@property (nonatomic, strong) NSString *titleStr;
@property (nonatomic, strong) NSString *imageUrl;
PropertyString(pinyinStr);
PropertyString(nameStr);
PropertyString(wuxingStr);
@end
