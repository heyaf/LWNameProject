//
//  AppDelegate+setting.m
//  getName
//
//  Created by mac on 2019/3/29.
//  Copyright © 2019 mac. All rights reserved.
//

#import "AppDelegate+setting.h"
#import "TBTabBarController.h"



#import <AdSupport/AdSupport.h>

@implementation AppDelegate (setting)
- (void) initWindows{
    
    [self configHttpAPI];
    
    self.window.rootViewController = [[TBTabBarController alloc] init];
}

+ (AppDelegate *)shareAppDelegate{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (void)configHttpAPI {
    [FGRequestCenter setupConfig:^(FGRequestConfig * _Nonnull config) {
        //默认的请求服务器地址...
        config.generalServer =  @"http://name.daomobile.cn/api/fugui/ios/v2/";
        //返回数据的线程,若不设置,默认子线程...
        config.callbackQueue = dispatch_get_main_queue();
        //路径中拼接,与服务器约定的一些不会改动的参数,比如:渠道,系统版本...
        config.generalParameters = @{
                                     @"appname":@"naming_fugui_iphone",
                                     @"client":@"iPhone",
                                     @"device":@"iPhone",
                                     @"market":@"appstore",
                                     @"openudid":@"82257E72-44DC-43AD-A6AF-26BF2DF4B676",
                                     @"sign":@"52ece8b5537a9ddbdbc8e3a478fa64ed",
                                     @"ver":@"1.8",
                                     @"idfa":[self getIDFA],
                                     @"user_id":@""
                                     };
        //路径中拼接,与服务器约定的一些会改动的参数,比如:网络状态,请求时间戳...
        config.realTimeParametersBlock = ^NSDictionary * _Nonnull{
            return @{
//                     @"time":@"---",
//                     @"network":@"---"
                     };
        };
    }];
}
// 获取IDFA的方法
-(NSString *)getIDFA
{
    SEL advertisingIdentifierSel = sel_registerName("advertisingIdentifier");
    SEL UUIDStringSel = sel_registerName("UUIDString");

    ASIdentifierManager *manager = [ASIdentifierManager sharedManager];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    if([manager respondsToSelector:advertisingIdentifierSel]) {

        id UUID = [manager performSelector:advertisingIdentifierSel];

        if([UUID respondsToSelector:UUIDStringSel]) {

            return [UUID performSelector:UUIDStringSel];

        }

    }
#pragma clang diagnostic pop
    return nil;
}

-(UIViewController *)getCurrentVC{
    
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}

-(UIViewController *)getCurrentUIVC
{
    UIViewController  *superVC = [self getCurrentVC];
    
    if ([superVC isKindOfClass:[UITabBarController class]]) {
        
        UIViewController  *tabSelectVC = ((UITabBarController*)superVC).selectedViewController;
        
        if ([tabSelectVC isKindOfClass:[UINavigationController class]]) {
            
            return ((UINavigationController*)tabSelectVC).viewControllers.lastObject;
        }
        return tabSelectVC;
    }else
        if ([superVC isKindOfClass:[UINavigationController class]]) {
            
            return ((UINavigationController*)superVC).viewControllers.lastObject;
        }
    return superVC;
}

@end
