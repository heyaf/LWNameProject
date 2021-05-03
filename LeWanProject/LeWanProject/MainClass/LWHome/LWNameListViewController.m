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
<<<<<<< HEAD
#import <GDTNativeExpressProAdManager.h>
#import <GDTNativeExpressProAdView.h>
#import <GDTNativeExpressRewardVideoAd.h>

@interface LWNameListViewController ()<GDTNativeExpressProAdManagerDelegate, GDTNativeExpressProAdViewDelegate,GDTNativeExpressRewardedVideoAdDelegate>
PropertyString(bazi_guanjainzi); //八字关键字
PropertyString(bazi_jiexi);  //八字解析
PropertyNSMutableArray(NameArray);
@property (nonatomic, strong) NSMutableArray *expressAdViews;
@property (nonatomic, strong) GDTNativeExpressRewardVideoAd *rewardVideoAd;

@property (nonatomic, strong) GDTNativeExpressProAdManager *adManager;
=======


@interface LWNameListViewController ()
PropertyString(bazi_guanjainzi); //八字关键字
PropertyString(bazi_jiexi);  //八字解析
PropertyNSMutableArray(NameArray);
>>>>>>> parent of 0c23411... 1.2.0版本提交审核
@end

@implementation LWNameListViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = KWhiteColor;
    self.navigationItem.title = @"吉名";
   
    
    [self creatGudingUI];
    [self creatNameListNetWorking];

<<<<<<< HEAD
    BOOL ispaysuc = [kUserDefaults objectForKey:kVIPPaySuc];
    if (!ispaysuc) {
        [self setJILISDK];
        [self setGDST];


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
=======
    
>>>>>>> parent of 0c23411... 1.2.0版本提交审核
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


@end
