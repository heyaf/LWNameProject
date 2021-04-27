//
//  LWFindMoreVC.m
//  LeWanProject
//
//  Created by iOS on 2021/4/27.
//  Copyright © 2021 mac. All rights reserved.
//

#import "LWFindMoreVC.h"
#import "LWFindDetailViewController.h"
#import <GDTUnifiedBannerView.h>
@interface LWFindMoreVC ()<GDTUnifiedBannerViewDelegate>
@property (nonatomic, strong) GDTUnifiedBannerView *bannerView;

@end

@implementation LWFindMoreVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"发现更多";

    self.view.backgroundColor = KWhiteColor;
    NSArray *imageArr = @[@"shier",@"qimingyaosu",@"aijiaxing"];
    for (int i =0; i<3; i++) {
        UIButton *btn = [UIButton buttonWithType:0];
        btn.frame = CGRectMake(15, kTopHeight+i*170, kScreenWidth-30, 160);

        btn.tag = 500+i;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth-30, 160)];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.image = [UIImage imageNamed:imageArr[i]];

        [btn addSubview:imageView];

        [self.view addSubview:btn];
        [btn
         addTarget:self action:@selector(btnclicked:) forControlEvents:UIControlEventTouchUpInside];

        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = 10;

        btn.layer.borderWidth = 3;
        btn.layer.borderColor = [UIColor systemPinkColor].CGColor;
    }

    [self loadAdAndShow:nil];
}
- (void)loadAdAndShow:(id)sender {
      if (self.bannerView.superview) {
          [self.bannerView removeFromSuperview];
      }
      [self.view addSubview:self.bannerView];
      [self.bannerView loadAdAndShow];
  }


- (GDTUnifiedBannerView *)bannerView
  {
    if (!_bannerView) {
        CGRect rect = CGRectMake(0, kScreenHeight-kTopHeight-HitoTabBarHeight, kScreenWidth, 100);
        _bannerView = [[GDTUnifiedBannerView alloc]
                       initWithFrame:rect
                       placementId:kGDTSDKBanner
                       viewController:self];
        _bannerView.animated = YES;
        _bannerView.autoSwitchInterval = 5;
        _bannerView.delegate = self;
    }
    return _bannerView;
  }
-(void)btnclicked:(UIButton *)btn{
    NSArray *urlArr = @[
    @"http://share.aimx777.com/qiming_web/qm_shengxiao/#/index",
    @"http://share.aimx777.com/qiming_web/qm_jiangjiu/#/index",
    @"http://share.aimx777.com/qiming_web/qm_qiyuan/#/index"
    ];
    NSArray *titleArr = @[@"十二生肖",
    @"起名讲究",
    @"姓氏起源"];
    NSInteger tag = btn.tag-500;
    
    LWFindDetailViewController *findVC = [[LWFindDetailViewController alloc] init];
    findVC.urlStr = urlArr[tag];
    findVC.titleStr = titleArr[tag];
    findVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:findVC animated:YES];
    
}
#pragma mark - GDTUnifiedBannerViewDelegate
/**
 *  请求广告条数据成功后调用
 *  当接收服务器返回的广告数据成功后调用该函数
 */
- (void)unifiedBannerViewDidLoad:(GDTUnifiedBannerView *)unifiedBannerView
{
    NSLog(@"%s",__FUNCTION__);
    NSLog(@"unified banner did load");
}

/**
 *  请求广告条数据失败后调用
 *  当接收服务器返回的广告数据失败后调用该函数
 */

- (void)unifiedBannerViewFailedToLoad:(GDTUnifiedBannerView *)unifiedBannerView error:(NSError *)error
{
    NSLog(@"%s",__FUNCTION__);
}

/**
 *  banner2.0曝光回调
 */
- (void)unifiedBannerViewWillExpose:(nonnull GDTUnifiedBannerView *)unifiedBannerView {
    NSLog(@"%s",__FUNCTION__);
}

/**
 *  banner2.0点击回调
 */
- (void)unifiedBannerViewClicked:(GDTUnifiedBannerView *)unifiedBannerView
{
    NSLog(@"%s",__FUNCTION__);
}

/**
 *  应用进入后台时调用
 *  当点击应用下载或者广告调用系统程序打开，应用将被自动切换到后台
 */
- (void)unifiedBannerViewWillLeaveApplication:(GDTUnifiedBannerView *)unifiedBannerView
{
    NSLog(@"%s",__FUNCTION__);
}

/**
 *  全屏广告页已经被关闭
 */
- (void)unifiedBannerViewDidDismissFullScreenModal:(GDTUnifiedBannerView *)unifiedBannerView
{
    NSLog(@"%s",__FUNCTION__);
}

/**
 *  全屏广告页即将被关闭
 */
- (void)unifiedBannerViewWillDismissFullScreenModal:(GDTUnifiedBannerView *)unifiedBannerView
{
    NSLog(@"%s",__FUNCTION__);
}

/**
 *  banner2.0广告点击以后即将弹出全屏广告页
 */
- (void)unifiedBannerViewWillPresentFullScreenModal:(GDTUnifiedBannerView *)unifiedBannerView
{
    NSLog(@"%s",__FUNCTION__);
}

/**
 *  banner2.0广告点击以后弹出全屏广告页完毕
 */
- (void)unifiedBannerViewDidPresentFullScreenModal:(GDTUnifiedBannerView *)unifiedBannerView
{
    NSLog(@"%s",__FUNCTION__);
}

/**
 *  banner2.0被用户关闭时调用
 */
- (void)unifiedBannerViewWillClose:(nonnull GDTUnifiedBannerView *)unifiedBannerView {
    self.bannerView = nil;
    NSLog(@"%s",__FUNCTION__);
}
@end
