//
//  LWChargeNameViewController.m
//  LeWanProject
//
//  Created by iOS on 2021/3/17.
//  Copyright © 2021 mac. All rights reserved.
//

#import "LWChargeNameViewController.h"
#import <BAPickView_OC.h>
#import "LWNameDetailViewController.h"
#import <PGDatePicker/PGDatePickManager.h>
#import <AdSupport/AdSupport.h>

@interface LWChargeNameViewController ()<UITextFieldDelegate>
@property (nonatomic,strong)ZXTextField *textfile;

@property (nonatomic,strong)ZXTextField *textfile1;
@property (nonatomic,strong)ZXTextField *textfile2;
@property (nonatomic,strong) UIView *sexSeclectVIew;

@property (nonatomic,strong) NSString *nametype;
@property (nonatomic,strong) NSString *sextype;

@property (nonatomic,strong) NSString *resultString;
@property (nonatomic,strong) NSString *xingStr;
@property (nonatomic,strong) NSString *MingStr;

@property (nonatomic,strong) NSString *dateStr;

PropertyString(bazi_id);

@end

@implementation LWChargeNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGB(242, 242, 242);
    self.navigationItem.title = @"测名";
    UIImageView *imageview = [[UIImageView alloc] initWithFrame:self.view.frame];
    imageview.image = IMAGE_NAMED(@"104");
    [self.view addSubview:imageview];
    //    self
    
    
    _nametype = @"2";
    _sextype = @"2";
    
    [self CreatData];
    [self creatUI];
}

- (void)creatUI{
//    [self createMoreBtn];
    
    CGRect frame = CGRectMake(50, 80, KScreenWidth-100, 40);
    _textfile = [[ZXTextField alloc] initWithFrame:frame withIcon:@"xingshi.png" withPlaceholderText:@"姓"];
    _textfile.frame = frame;
    _textfile.inputText.tag =199;
    _textfile.inputText.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _textfile.inputText.autocorrectionType = UITextAutocorrectionTypeNo;
    _textfile.inputText.keyboardType = UIKeyboardTypeDefault;
    _textfile.inputText.delegate = self;
    _textfile.inputText.textColor = KGrayColor;
    UIView *view = [[UIView alloc] initWithFrame:frame];
    [self.view addSubview:view];
    ViewBorderRadius(view, 20, 0.5, KRedColor);
    
    CGRect frame1 = CGRectMake(50, 100+30+20, KScreenWidth-100, 40);
    _textfile1 = [[ZXTextField alloc] initWithFrame:frame1 withIcon:@"name.png" withPlaceholderText:@"名字"];
    _textfile1.frame = frame1;
    _textfile1.inputText.tag =200;
    _textfile1.inputText.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _textfile1.inputText.autocorrectionType = UITextAutocorrectionTypeNo;
    _textfile1.inputText.keyboardType = UIKeyboardTypeDefault;
    _textfile1.inputText.delegate = self;
    _textfile1.inputText.textColor = KGrayColor;
    UIView *view1 = [[UIView alloc] initWithFrame:frame1];
    [self.view addSubview:view1];
    ViewBorderRadius(view1, 20, 0.5, KRedColor);
    
    [self.view addSubview:_textfile];

    [self.view addSubview:_textfile1];
    
    CGRect frame2 = CGRectMake(50, 100+30+20+30+40, KScreenWidth-100, 40);
    _textfile2 = [[ZXTextField alloc] initWithFrame:frame2 withIcon:@"birthday.png" withPlaceholderText:@"出生日期"];
    _textfile2.frame = frame2;
    _textfile2.inputText.tag =201;
    _textfile2.inputText.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _textfile2.inputText.autocorrectionType = UITextAutocorrectionTypeNo;
    _textfile2.inputText.keyboardType = UIKeyboardTypeDefault;
    _textfile2.inputText.delegate = self;
    _textfile2.inputText.textColor = KGrayColor;
    
    [self.view addSubview:_textfile2];
    
    UIButton *dataBtn = [UIButton buttonWithType:0];
    dataBtn.frame = frame2;
    ViewBorderRadius(dataBtn, 20, 0.5, KRedColor);
    [dataBtn addTarget:self action:@selector(dataButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:dataBtn];
    
    [self creatMoreSexBtn];
    
    UIButton *makesureBtn = [UIButton buttonWithType:0];
    [self.view addSubview:makesureBtn];
    [makesureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.sexSeclectVIew).mas_offset(@(30+40));
        make.left.mas_equalTo(self.view).mas_offset(80);
        make.right.mas_equalTo(self.view).mas_offset(-80);
        make.height.mas_offset(50);
    }];
    ViewRadius(makesureBtn, 25);
    makesureBtn.backgroundColor = KRedColor;
    [makesureBtn setTitle:@"确定" forState:0];
    [makesureBtn setTitleColor:KWhiteColor forState:0];
    [makesureBtn addTarget:self action:@selector(makesureBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
}
- (void)createMoreBtn {
    
    
    NSMutableArray* buttonsArray = [NSMutableArray arrayWithCapacity:3];
    CGFloat margin = KScreenWidth-160-100;
    CGRect btnRect = CGRectMake(50, 100, 80, 20);
    NSArray *NameArr = @[@"双名", @"单名"];
    for (int i=0;i<NameArr.count;i++) {
        NSString* optionTitle = NameArr[i];
        RadioButton* btn = [[RadioButton alloc] initWithFrame:btnRect];
        [btn addTarget:self action:@selector(onRadioButtonValueChanged1:) forControlEvents:UIControlEventValueChanged];
        btnRect.origin.x += (margin+100);
        btn.tag = 300+i;
        [btn setTitle:optionTitle forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:17];
        [btn setImage:[UIImage imageNamed:@"ordia.png"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"ordia_sec"] forState:UIControlStateSelected];
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, 6, 0, 0);
        [self.view addSubview:btn];
        [buttonsArray addObject:btn];
    }
    
    [buttonsArray[0] setGroupButtons:buttonsArray]; // 把按钮放进群组中
    
    [buttonsArray[0] setSelected:YES]; // 初始化第一个按钮为选中状态
    
}
- (void)creatMoreSexBtn{
    _sexSeclectVIew = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 30)];
    [self.view addSubview:_sexSeclectVIew];
    [_sexSeclectVIew mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self->_textfile2).mas_offset(@(20+40));
        make.height.mas_offset(@(30));
    }];
    
    NSMutableArray* buttonsArray = [NSMutableArray arrayWithCapacity:3];
    CGFloat margin = KScreenWidth-160-100;
    CGRect btnRect = CGRectMake(50, 10, 80, 20);
    NSArray *NameArr = @[@"男", @"女"];
    for (int i=0;i<NameArr.count;i++) {
        NSString* optionTitle = NameArr[i];
        RadioButton* btn = [[RadioButton alloc] initWithFrame:btnRect];
        [btn addTarget:self action:@selector(onRadioButtonValueChanged2:) forControlEvents:UIControlEventValueChanged];
        btnRect.origin.x += (margin+100);
        btn.tag = 200+i;
        [btn setTitle:optionTitle forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:17];
        [btn setImage:[UIImage imageNamed:@"ordia.png"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"ordia_sec"] forState:UIControlStateSelected];
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, 6, 0, 0);
        [_sexSeclectVIew addSubview:btn];
        [buttonsArray addObject:btn];
    }
    
    [buttonsArray[0] setGroupButtons:buttonsArray]; // 把按钮放进群组中
    
    [buttonsArray[0] setSelected:YES]; // 初始化第一个按钮为选中状态
}
- (void) CreatData{
   
    
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
#pragma mark ---日期选择按钮点击---
- (void)dataButtonClicked{
    [self.textfile1.inputText resignFirstResponder];
    [self.textfile.inputText resignFirstResponder];

    PGDatePickManager *datePickManager = [[PGDatePickManager alloc]init];
    PGDatePicker *datePicker = datePickManager.datePicker;
    datePicker.datePickerMode = PGDatePickerModeDateHourMinute;
    datePickManager.confirmButtonTextColor = KRedColor;
    [self presentViewController:datePickManager animated:false completion:nil];
    
    datePicker.selectedDate = ^(NSDateComponents *dateComponents) {
        NSString *month = dateComponents.month<10?[NSString stringWithFormat:@"0%li",(long)dateComponents.month]:kStringFormat(@"%li",(long)dateComponents.month);
        NSString *day = dateComponents.day<10?[NSString stringWithFormat:@"0%li",(long)dateComponents.day]:kStringFormat(@"%li",(long)dateComponents.day);
        NSString *dateStr = [NSString stringWithFormat:@"%li-%@-%@",(long)dateComponents.year,month,day];
        self->_textfile2.inputText.text = [NSString stringWithFormat:@"%li-%@-%@ %li:%li",(long)dateComponents.year,month,day,(long)dateComponents.hour,(long)dateComponents.minute];
        self.dateStr = dateStr;
        self->_textfile2.inputText.backgroundColor = RGB(231, 231, 231);
  
    };
//    [BAKit_PickerView ba_creatPickerViewWithType:BAKit_PickerViewTypeDate configuration:^(BAKit_PickerView *tempView) {
//
//        // 可以自由定制 NSDateFormatter
//        tempView.dateMode = BAKit_PickerViewDateModeDate;
//        tempView.dateType = BAKit_PickerViewDateTypeYMD;
//        //        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//        //        formatter.dateFormat = @"yyyy年MM月dd日 HH时";
//        //        tempView.customDateFormatter = formatter;
//        // 可以自由定制按钮颜色
//        tempView.ba_buttonTitleColor_sure = [UIColor redColor];
//        tempView.ba_buttonTitleColor_cancle = [UIColor redColor];
//        tempView.animationType = BAKit_PickerViewAnimationTypeBottom;
//
//
//    } block:^(NSString *resultString) {
//        self.dateStr = resultString;
//        self->_textfile2.inputText.backgroundColor = RGB(231, 231, 231);
//
//        self->_textfile2.inputText.text = resultString;
//    }];
    
}

#pragma mark ---确定按钮---
-(void)makesureBtnClicked{
    if (self.dateStr.length==0||self.textfile1.inputText.text.length==0||self.textfile.inputText.text.length==0) {
        [SVProgressHUD showErrorWithStatus:@"请完整输入您的信息"];
    }else{
        _xingStr = self.textfile.inputText.text;
        _MingStr = self.textfile1.inputText.text;
        [self getNetWorking];
    }
    
    
    DLog(@"确定按钮%@,%@,%@,%@",_nametype,_sextype,self.textfile1.inputText.text,_dateStr);}

- (void)getNetWorking{
    
    AFHTTPSessionManager *manager =[AFHTTPSessionManager manager];

    NSDictionary *dic = @{
                        @"first_name":self->_xingStr,
                        @"name_type":self.nametype,
                        @"sex":self.sextype,
                        @"birthday":NSStringFormat(@"%@ 12:00:00",self.dateStr),
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
    NSString *urlStr = @"get_bazi_id";
    [[SCCatWaitingHUD sharedInstance] animateWithInteractionEnabled:NO];

    [manager POST:[baseUrl stringByAppendingString:urlStr] parameters:dic headers:@{} progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSDictionary *dateDic = (NSDictionary *)responseObject[@"data"];
            [[SCCatWaitingHUD sharedInstance] stop];

            self.bazi_id = dateDic[@"bazi_id"];
            [self goDetailController];
            [[SCCatWaitingHUD sharedInstance] stop];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [[SCCatWaitingHUD sharedInstance] stop];

            [SVProgressHUD showErrorWithStatus:@"网络请求失败，请稍后重试"];
        }];
    

}
-(void)goDetailController{
    LWNameDetailViewController *nameVC = [[LWNameDetailViewController alloc] init];
    nameVC.xing = self.xingStr ;
    nameVC.mingzi = self.MingStr;
    nameVC.bazi_id= self.bazi_id;
    nameVC.hidesBottomBarWhenPushed = YES;

    [self.navigationController pushViewController:nameVC animated:YES];
}
#pragma mark ---单选按钮---
- (void)onRadioButtonValueChanged1:(id)sender{
    UIButton *btn = (UIButton *)sender;
    
    DLog(@"---------%li",btn.tag);
    if (btn.tag ==500) {
        _nametype = @"1";
    }else{
        _nametype = @"2";
    }
}
- (void)onRadioButtonValueChanged2:(id)sender{
    UIButton *btn = (UIButton *)sender;
    if (btn.tag ==400) {
        _sextype = @"2";
    }else{
        _sextype = @"1";
    }
    DLog(@"---------%li",btn.tag);
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField.text.length <= 0 && textField.tag ==199) {
        [_textfile textBeginEditing];
    }else if (textField.text.length <= 0 && textField.tag ==200) {
        [_textfile1 textBeginEditing];
    }else if (textField.text.length <= 0 && textField.tag ==201){
        [_textfile2 textEndEditing];
        
    }
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.text.length <= 0 && textField.tag ==199) {
        [_textfile textEndEditing];
    }else if (textField.text.length <= 0 && textField.tag ==200) {
        [_textfile1 textEndEditing];
    }else if (textField.text.length <= 0 && textField.tag ==201){
    }
}


-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.translucent = NO;
    BOOL ispaysuc = [kUserDefaults objectForKey:kVIPPaySuc];
    if (ispaysuc) {
        self.bannerView = nil;
        
    }

}
-(void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBar.translucent = YES;

}

@end
