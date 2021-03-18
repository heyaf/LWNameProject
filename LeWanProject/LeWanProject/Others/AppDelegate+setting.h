//
//  AppDelegate+setting.h
//  getName
//
//  Created by mac on 2019/3/29.
//  Copyright © 2019 mac. All rights reserved.
//

#import "AppDelegate.h"

NS_ASSUME_NONNULL_BEGIN
@class JMConfig;
@interface AppDelegate (setting)
- (void) initWindows;
+ (AppDelegate *)shareAppDelegate;
-(UIViewController *)getCurrentUIVC;
-(UIViewController *)getCurrentVC;
@end

NS_ASSUME_NONNULL_END
