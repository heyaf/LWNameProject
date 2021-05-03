//
//  LWFindDetailViewController.m
//  LeWanProject
//
//  Created by iOS on 2021/4/27.
//  Copyright © 2021 mac. All rights reserved.
//

#import "LWFindDetailViewController.h"
#import <WebKit/WKWebView.h>
#import <WebKit/WKWebViewConfiguration.h>
#import <WebKit/WKUserContentController.h>
#import <WebKit/WKPreferences.h>
#import <GDTNativeExpressRewardVideoAd.h>
@interface LWFindDetailViewController ()<GDTNativeExpressRewardedVideoAdDelegate>
@property (nonatomic, strong) GDTNativeExpressRewardVideoAd *rewardVideoAd;

@property (nonatomic,strong) WKWebView *webView;
@end

@implementation LWFindDetailViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = self.titleStr;

    [self initWKWebView];
    
    BOOL ispaysuc = [kUserDefaults objectForKey:kVIPPaySuc];
    if (!ispaysuc) {
        [self setJILISDK];

    }
}
-(void)setJILISDK{
    
    

    self.rewardVideoAd = [[GDTNativeExpressRewardVideoAd alloc] initWithPlacementId:kJIliAPI];
         self.rewardVideoAd.delegate = self;
         self.rewardVideoAd.videoMuted = NO; // 设置模板激励视频是否静音
         [self.rewardVideoAd loadAd];
}
- (void)gdt_nativeExpressRewardVideoAdVideoDidLoad:(GDTNativeExpressRewardVideoAd *)expressRewardVideoAd
{
    NSLog(@"视频文件加载成功");
    if (!self.rewardVideoAd.isAdValid) {
        return;
    }
    [SXAlertView showWithTitle:@"是否开通VIP" message:@"VIP用户可以畅享无广告优质体验，是否立即开通" cancelButtonTitle:@"观看广告" otherButtonTitle:@"去开通" clickButtonBlock:^(SXAlertView * _Nonnull alertView, NSInteger buttonIndex) {
        if (buttonIndex==1) {
            [self.navigationController popToRootViewControllerAnimated:NO];
            KPostNotification(kSendMineVC, nil);
        }else{
            [self.rewardVideoAd showAdFromRootViewController:self];

        }
    }];
}

- (void)initWKWebView
{
    //创建并配置WKWebView的相关参数
    //1.WKWebViewConfiguration:是WKWebView初始化时的配置类，里面存放着初始化WK的一系列属性；
    //2.WKUserContentController:为JS提供了一个发送消息的通道并且可以向页面注入JS的类，WKUserContentController对象可以添加多个scriptMessageHandler；
    //3.addScriptMessageHandler:name:有两个参数，第一个参数是userContentController的代理对象，第二个参数是JS里发送postMessage的对象。添加一个脚本消息的处理器,同时需要在JS中添加，window.webkit.messageHandlers..postMessage()才能起作用。
    //以下都属于初始化基本设置
    WKWebViewConfiguration*configuration = [[WKWebViewConfiguration alloc]init];

    WKUserContentController*userContentController = [[WKUserContentController alloc]init];

    //getUserid 和js 约定的对象名
    [userContentController addScriptMessageHandler:self name:@"getUserid"];

    configuration.userContentController= userContentController;

    WKPreferences *preferences = [WKPreferences new];

    preferences.javaScriptCanOpenWindowsAutomatically=YES;

//    preferences.minimumFontSize=40.0;

    configuration.preferences= preferences;

    //在交互的时候出现问题，xcode会报错  一定要注意 在创建了wkwebView的时候  configuration:configuration
    self.webView = [[WKWebView alloc] initWithFrame:self.view.frame configuration:configuration];

    //设置访问的URL

    NSURL*url = [NSURL URLWithString:_urlStr];

    //根据URL创建请求

    NSURLRequest*request = [NSURLRequest requestWithURL:url];

    // WKWebView加载请求

    [self.webView loadRequest:request];

//    self.webView.UIDelegate=self;

    self.webView.backgroundColor= [UIColor whiteColor];

    [self.view addSubview:self.webView];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
