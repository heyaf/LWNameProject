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
@interface LWNameListViewController ()
PropertyString(bazi_guanjainzi); //八字关键字
PropertyString(bazi_jiexi);  //八字解析
PropertyNSMutableArray(NameArray);
@end

@implementation LWNameListViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = KWhiteColor;
    self.navigationItem.title = @"吉名";
   
    
    [self creatGudingUI];
    [self creatNameListNetWorking];

    
}

- (void)creatNameListNetWorking{
    [MBProgressHUD showInfoMessage:@"正在加载，请稍等..."];
    [FGRequestCenter sendRequest:^(FGRequestItem * _Nonnull item) {
        //请求的路径
        item.api = @"qiming";
        //配置请求的参数
        item.parameters = @{
                            @"first_name":self.firstname,
                            @"name_type":self.name_type,
                            @"bazi_id":self.bazi_id,
                            
                            };
        //若此接口需要调用与默认配置的服务器不同,可在此修改separateServer属性
        //请求的间隔,避免频繁发送请求给服务器,默认是:2s,如有需要单独设置,也可修改默认值
        item.requestInterval = 2.f;
        //如果在间隔内发送请求,到时后是否继续处理,默认是NO,不做处理
        item.isFrequentContinue = NO;
        item.httpMethod = 1;
        //失败后重复次数,默认为0
        item.retryCount = 1;
    } onSuccess:^(id  _Nullable responseObject) {
        [MBProgressHUD hideHUD];
        self.NameArray = [LWNameModel arrayOfModelsFromDictionaries:responseObject[@"tjm"] error:nil];
        [self creatDate];
        self.bazi_guanjainzi = responseObject[@"info"][@"jianPi"][@"tag"];
        self.bazi_jiexi = responseObject[@"info"][@"jianPi"][@"content"];
        [self creatUI];
        
    } onFailure:^(NSError * _Nullable error) {
//        NSData *errorData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
//        NSDictionary *serializedData = [NSJSONSerialization JSONObjectWithData: errorData options:kNilOptions error:nil];
        [MBProgressHUD showErrorMessage:error.description];

//        NSLog(@"error-123-%@",serializedData);
    } onFinished:^(id  _Nullable responseObject, NSError * _Nullable error) {
        
    }];
    
    
    
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
