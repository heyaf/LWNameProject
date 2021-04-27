//
//  LWNameListViewController.m
//  LeWanProject
//
//  Created by iOS on 2021/3/17.
//  Copyright © 2021 mac. All rights reserved.
//

#import "LWNameListViewController.h"
#import "ZYCarView.h"
#import "ZYCarModel.h"
#import "LWNameModel.h"
#import "LWNameDetailViewController.h"
#import <AdSupport/AdSupport.h>
#import <GDTNativeExpressProAdManager.h>
#import <GDTNativeExpressProAdView.h>

@interface LWNameListViewController ()<GDTNativeExpressProAdManagerDelegate, GDTNativeExpressProAdViewDelegate>
PropertyString(bazi_guanjainzi); //八字关键字
PropertyString(bazi_jiexi);  //八字解析
PropertyNSMutableArray(NameArray);
@property (nonatomic, strong) NSMutableArray *expressAdViews;

@property (nonatomic, strong) GDTNativeExpressProAdManager *adManager;
@end

@implementation LWNameListViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = KWhiteColor;
    self.navigationItem.title = @"吉名";
   
    
    [self creatGudingUI];
    [self creatNameListNetWorking];

    [self setGDST];
}
-(void)setGDST{
    GDTAdParams *adParams = [[GDTAdParams alloc] init];
    adParams.adSize = CGSizeMake(kScreenWidth, 100);
    adParams.maxVideoDuration = 30;
    adParams.minVideoDuration = 5;
    adParams.detailPageVideoMuted = YES;
    adParams.videoMuted = YES;
    adParams.videoAutoPlayOnWWAN = YES;
    self.adManager = [[GDTNativeExpressProAdManager alloc] initWithPlacementId:kplacementId
                                                                           adPrams:adParams];
    self.adManager.delegate = self;
    [self.adManager loadAd:1];
}

- (void)creatNameListNetWorking{
    AFHTTPSessionManager *manager =[AFHTTPSessionManager manager];

    NSDictionary *dic = @{
                        @"first_name":self.firstname,
                        @"name_type":self.name_type,
                        @"bazi_id":self.bazi_id,
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
    NSString *urlStr = @"qiming";
    [[SCCatWaitingHUD sharedInstance] animateWithInteractionEnabled:NO];

    [manager POST:[baseUrl stringByAppendingString:urlStr] parameters:dic headers:@{} progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSDictionary *dateDic = (NSDictionary *)responseObject[@"data"];
            [[SCCatWaitingHUD sharedInstance] stop];
            self.NameArray = [LWNameModel arrayOfModelsFromDictionaries:dateDic[@"tjm"] error:nil];
            [self creatDate];
            self.bazi_guanjainzi = dateDic[@"info"][@"jianPi"][@"tag"];
            self.bazi_jiexi = dateDic[@"info"][@"jianPi"][@"content"];
            [self creatUI];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [[SCCatWaitingHUD sharedInstance] stop];

            [SVProgressHUD showErrorWithStatus:@"网络请求失败，请稍后重试"];
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
-(void)creatDate{
    NSMutableArray *array = [[NSMutableArray alloc]init];
  
    for (int i = 0; i<self.NameArray.count; i++) {
        LWNameModel *namemodel = self.NameArray[i];
        ZYCarModel *model = [[ZYCarModel alloc]init];
        model.imageUrl = [NSString stringWithFormat:@"10%d",i%6];
        model.pinyinStr = namemodel.pinYin;
        model.nameStr = namemodel.jiMing;
        model.wuxingStr = namemodel.wuXing;
        
        [array addObject:model];
    }
    ZYCarView *carView = [[ZYCarView alloc]initWithFrame:CGRectMake(0,80 , self.view.frame.size.width, 240)];
    carView.block = ^(NSString *name) {
        [self jiexiNameWithName:name];
    };
    [carView setArrayData:array superScrollView:nil];
    [self.view addSubview:carView];
}
-(void)jiexiNameWithName:(NSString *)name{
    
    LWNameDetailViewController *namedevc = [[LWNameDetailViewController alloc] init];
    namedevc.xing = [name substringToIndex:1];
    namedevc.mingzi = [name substringFromIndex:1];
    namedevc.bazi_id = self.bazi_id;
    [self.navigationController pushViewController:namedevc animated:YES];
    
}
-(void)creatUI{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(2, 240+80+20, KScreenWidth-4, 80)];
    [self.view addSubview:view];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, KScreenWidth-20, 18)];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:NSStringFormat( @"八字精批:【%@】",_bazi_guanjainzi)];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(str.length-_bazi_guanjainzi.length-1,_bazi_guanjainzi.length)];
    label.attributedText = str;
    label.font = SYSTEMFONT(15.0);
    [view addSubview:label];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 23, KScreenWidth-20, 57)];
    label1.text = _bazi_jiexi;
    label1.numberOfLines = 0;
    label1.font = SYSTEMFONT(13.0);
    label1.textColor =KGray2Color;
    [view addSubview:label1];
    ViewBorderRadius(view, 5, 0.5, RGB(230, 230, 230));
}
-(void)creatGudingUI{
    
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(10, 240+80+20+80+20, KScreenWidth-20, 20)];
    label2.text = @"老师温馨提示：如何挑选富贵好名?";
    label2.numberOfLines = 0;
    label2.font = SYSTEMFONT(15.0);
//    label2.textColor =KGrayColor;
    [self.view addSubview:label2];
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(10, 240+80+20+80+20+20, KScreenWidth-20, 140)];
    label3.text = @"1、根据八字看五行含量、日柱旺衰，起名时要补偏救弊。如：喜用木，那么最好能选到五行属木的字体；\n2、扶弱抑强选五格，避开凶数；\n3、根据五格选择笔画组合；\n4、根据笔画查字典看字义。";
    label3.numberOfLines = 0;
    label3.font = SYSTEMFONT(15.0);
    label3.textColor =KGray2Color;
    [self.view addSubview:label3];
    
}
#pragma mark - GDTNativeExpressProAdManagerDelegete
/**
 * 拉取广告成功的回调
 */
- (void)gdt_nativeExpressProAdSuccessToLoad:(GDTNativeExpressProAdManager *)adManager views:(NSArray<__kindof GDTNativeExpressProAdView *> *)views
{
    NSLog(@"成功%s",__FUNCTION__);
    self.expressAdViews = [NSMutableArray arrayWithArray:views];
    if (self.expressAdViews.count) {
        [self.expressAdViews enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            GDTNativeExpressProAdView *adView = (GDTNativeExpressProAdView *)obj;
            adView.controller = self;
            adView.delegate = self;
            [adView render];
            NSLog(@"eCPM:%ld eCPMLevel:%@", [adView eCPM], [adView eCPMLevel]);
        }];
    }
    UIView *view = [self.expressAdViews objectAtIndex:0];
    UIView *adbgView = [[UIView alloc] initWithFrame:CGRectMake(0, 240+80+20+80+20+20+140, kScreenWidth, 300)];
    [adbgView addSubview:view];
    [self.view addSubview:adbgView];
}

/**
 * 拉取广告失败的回调
 */
- (void)gdt_nativeExpressProAdFailToLoad:(GDTNativeExpressProAdManager *)adManager error:(NSError *)error
{
    NSLog(@"%s",__FUNCTION__);
    NSLog(@"Express Ad Load Fail : %@",error);
}


#pragma mark - GDTNativeExpressProAdViewDelegate;
- (void)gdt_NativeExpressProAdViewRenderSuccess:(GDTNativeExpressProAdView *)nativeExpressAdView
{
    NSLog(@"%s",__FUNCTION__);
}

- (void)gdt_NativeExpressProAdViewRenderFail:(GDTNativeExpressProAdView *)nativeExpressProAdView
{
    
}

- (void)gdt_NativeExpressProAdViewClicked:(GDTNativeExpressProAdView *)nativeExpressAdView
{
    NSLog(@"%s",__FUNCTION__);
}

- (void)gdt_NativeExpressProAdViewClosed:(GDTNativeExpressProAdView *)nativeExpressAdView
{
    NSLog(@"%s",__FUNCTION__);
    [nativeExpressAdView removeFromSuperview];
    
}

- (void)gdt_NativeExpressProAdViewExposure:(GDTNativeExpressProAdView *)nativeExpressAdView
{
    NSLog(@"%s",__FUNCTION__);
}

- (void)gdt_NativeExpressProAdViewWillPresentScreen:(GDTNativeExpressProAdView *)nativeExpressAdView
{
    NSLog(@"%s",__FUNCTION__);
}

- (void)gdt_NativeExpressProAdViewDidPresentScreen:(GDTNativeExpressProAdView *)nativeExpressAdView
{
    NSLog(@"%s",__FUNCTION__);
}

- (void)gdt_NativeExpressProAdViewWillDissmissScreen:(GDTNativeExpressProAdView *)nativeExpressAdView
{
    NSLog(@"%s",__FUNCTION__);
}

- (void)gdt_NativeExpressProAdViewDidDissmissScreen:(GDTNativeExpressProAdView *)nativeExpressAdView
{
    NSLog(@"%s",__FUNCTION__);
}

- (void)gdt_NativeExpressProAdView:(GDTNativeExpressProAdView *)nativeExpressProAdView playerStatusChanged:(GDTMediaPlayerStatus)status
{
    NSLog(@"%s",__FUNCTION__);
}


@end
