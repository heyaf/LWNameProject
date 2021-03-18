//
//  LWNameDetailViewController.h
//  LeWanProject
//
//  Created by iOS on 2021/3/17.
//  Copyright © 2021 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class LWNameModel;
@interface LWNameDetailViewController : UIViewController
PropertyString(xing);
PropertyString(mingzi);
PropertyString(bazi_id);

@property (nonatomic,strong) LWNameModel *namemodel;
@end

NS_ASSUME_NONNULL_END
