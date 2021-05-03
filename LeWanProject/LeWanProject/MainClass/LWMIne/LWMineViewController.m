//
//  LWMineViewController.m
//  LeWanProject
//
//  Created by iOS on 2021/3/17.
//  Copyright © 2021 mac. All rights reserved.
//

#import "LWMineViewController.h"
#import "LZHPersonalCenterView.h"
#import "LWDetailSubViewController.h"
#import "LWMinePayViewController.h"
@interface LWMineViewController ()<LZHPersonalCenterViewDelegate>

@end

@implementation LWMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    NSArray * centerArr = @[@[@"升级VIP纯净版"],@[@"使用说明",@"清除缓存"],@[@"隐私条款",@"关于"],@[@"反馈"]] ;
    LZHPersonalCenterView * pcv = [[LZHPersonalCenterView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) CenterArr:centerArr isShowHeader:YES];
    pcv.delegate = self ;
    //按需求定是否需要
    pcv.extendCenterRightArr = @[@[@""],@[@"",@""],@[@"",@"",@""],@[@""]] ;
    [self.view addSubview:pcv];
}

-(void)didSelectRowTitle:(NSString *)title{
    LWDetailSubViewController *detailVC = [[LWDetailSubViewController alloc] init];
    detailVC.hidesBottomBarWhenPushed = YES;
    if ([title isEqualToString:@"清除缓存"]) {
        NSString *str = [self getCacheSize];
        NSString *infoStr = NSStringFormat(@"已清除%@缓存",str);
        [SVProgressHUD showSuccessWithStatus:infoStr];
    }else if ([title isEqualToString:@"使用说明"]){
        [SXAlertView showWithTitle:nil image:IMAGE_NAMED(@"bgBottom") cancelButtonTitle:nil otherButtonTitle:@"确定" clickButtonBlock:^(SXAlertView * _Nonnull alertView, NSInteger buttonIndex) {
            
        }];
        
    }else if ([title isEqualToString:@"隐私条款"]){
        detailVC.Title = @"隐私条款";
        detailVC.message = @"本应用尊重并保护所有使用服务用户的个人隐私权。为了给您提供更准确、更有个性化的服务，本应用会按照本隐私权政策的规定使用和披露您的个人信息。但本应用将以高度的勤勉、审慎义务对待这些信息。除本隐私权政策另有规定外，在未征得您事先许可的情况下，本应用不会将这些信息对外披露或向第三方提供。本应用会不时更新本隐私权政策。\n\n 适用范围\n(a) 在您注册本应用帐号时，您根据本应用要求提供的个人注册信息；\n(b) 在您使用本应用网络服务，或访问本应用平台网页时，本应用自动接收并记录的您的浏览器和计算机上的信息，包括但不限于您的IP地址、浏览器的类型、使用的语言、访问日期和时间、软硬件特征信息及您需求的网页记录等数据；\n\n请您妥善保护自己的个人信息，仅在必要的情形下向他人提供。如您发现自己的个人信息泄密，尤其是本应用用户名及密码发生泄露，请您立即联络本应用客服，以便本应用采取相应措施。";
        [self.navigationController pushViewController:detailVC animated:YES];
    }else if ([title isEqualToString:@"关于"]){
        detailVC.Title = @"关于";
        detailVC.message = @"本app的功能,完全是由计算机程序自动测算得出,非人工分析,鉴于计算机程序的局限性,本app所有的测试结果不作为您真正人生规划指导,仅做娱乐参考,如果用户使用本产品为参照出现意外,导致身体或财产损害,app开发团队概不负责";
        [self.navigationController pushViewController:detailVC animated:YES];
       
        
        
    }else if ([title isEqualToString:@"反馈"]){
        detailVC.Title = @"联系客服";
        detailVC.hasKefu = @"YES";
        detailVC.message = @"用着不爽？想吐槽我们？或者有好的建议与意见，欢迎联系我们的客服小哥\n我们会尽力解决的哦。\n\n客服微信:ccc666888ooo (ps:请备注好App名称)";
        [self.navigationController pushViewController:detailVC animated:YES];
       
    }else if ([title isEqualToString:@"升级VIP纯净版"]){
        
        BOOL hasPay = [kUserDefaults objectForKey:kVIPPaySuc];
        if (hasPay) {
            [SVProgressHUD showSuccessWithStatus:@"您已经是VIP会员，无需重复购买"];
            return;
        }
        LWMinePayViewController *payVC = [[LWMinePayViewController alloc] init];
        [self.navigationController pushViewController:payVC animated:YES];
    }
}

-(void)tapHeader{
    NSLog(@"点你个头") ;
}

-(NSString *)getCacheSize{
    
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains (NSCachesDirectory , NSUserDomainMask , YES) firstObject];
    // 获取“path”文件夹下的所有文件
    NSArray *subPathArr = [[NSFileManager defaultManager] subpathsAtPath:cachePath];
    
    NSString *filePath  = nil;
    NSInteger totleSize = 0;
    
    for (NSString *subPath in subPathArr){
        
        // 1. 拼接每一个文件的全路径
        filePath =[cachePath stringByAppendingPathComponent:subPath];
        // 2. 是否是文件夹，默认不是
        BOOL isDirectory = NO;
        // 3. 判断文件是否存在
        BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&isDirectory];
        
        // 4. 以上判断目的是忽略不需要计算的文件
        if (!isExist || isDirectory || [filePath containsString:@".DS"]){
            // 过滤: 1. 文件夹不存在  2. 过滤文件夹  3. 隐藏文件
            continue;
        }
        // 5. 指定路径，获取这个路径的属性
        NSDictionary *dict = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
        /**
         attributesOfItemAtPath: 文件夹路径
         该方法只能获取文件的属性, 无法获取文件夹属性, 所以也是需要遍历文件夹的每一个文件的原因
         */
        // 6. 获取每一个文件的大小
        NSInteger size = [dict[@"NSFileSize"] integerValue];
        // 7. 计算总大小
        totleSize += size;
    }
    //8. 将文件夹大小转换为 M/KB/B
    NSString *totleStr = nil;
    if (totleSize > 1000 * 1000){
        totleStr = [NSString stringWithFormat:@"%.2fM",totleSize / 1000.00f /1000.00f];
    }else if (totleSize > 1000){
        totleStr = [NSString stringWithFormat:@"%.2fKB",totleSize / 1000.00f ];
    }else{
        totleStr = [NSString stringWithFormat:@"%.2fB",totleSize / 1.00f];
    }
    return totleStr;
}


@end
