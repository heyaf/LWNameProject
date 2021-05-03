//
//  LWGetNameViewController.m
//  LeWanProject
//
//  Created by iOS on 2021/3/17.
//  Copyright © 2021 mac. All rights reserved.
//

#import "LWGetNameViewController.h"
#import <BAPickView_OC.h>
#import "LWNameListViewController.h"
#import <PGDatePicker/PGDatePickManager.h>
#import <AdSupport/AdSupport.h>

@interface LWGetNameViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)ZXTextField *textfile1;
@property (nonatomic,strong)ZXTextField *textfile2;
@property (nonatomic,strong) UIView *sexSeclectVIew;

@property (nonatomic,strong) NSString *nametype;
@property (nonatomic,strong) NSString *sextype;
@property (nonatomic,strong) UITableView *mainTableView;

@property (nonatomic,strong) NSArray *pinglunArray;
@property (nonatomic,strong) NSArray *phoneArray;
@property (nonatomic,strong) NSArray *imageArray;

@property (nonatomic,strong) NSTimer *mytimer;

@property (nonatomic,assign) NSInteger intTime;

@property (nonatomic,strong) NSString *xingStr;
@property (nonatomic,strong) NSString *dateStr;

PropertyString(bazi_id);

@end

@implementation LWGetNameViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    _intTime = 0;
    self.view.backgroundColor = RGB(242, 242, 242);
    self.navigationItem.title = @"起名";
    UIImageView *imageview = [[UIImageView alloc] initWithFrame:self.view.frame];
    imageview.image = IMAGE_NAMED(@"106");
    [self.view addSubview:imageview];
    
 
    _nametype = @"2";
    _sextype = @"2";
    
    
    [self CreatData];
    [self creatUI];
}

- (void)creatUI{
     [self createMoreBtn];
    CGRect frame = CGRectMake(50, 100+30+20, KScreenWidth-100, 40);
    _textfile1 = [[ZXTextField alloc] initWithFrame:frame withIcon:@"xingshi.png" withPlaceholderText:@"姓"];
    _textfile1.frame = frame;
    _textfile1.inputText.tag =200;
    _textfile1.inputText.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _textfile1.inputText.autocorrectionType = UITextAutocorrectionTypeNo;
    _textfile1.inputText.keyboardType = UIKeyboardTypeDefault;
    _textfile1.inputText.delegate = self;
    _textfile1.inputText.textColor = KGrayColor;
    UIView *view = [[UIView alloc] initWithFrame:frame];
    [self.view addSubview:view];
    ViewBorderRadius(view, 20, 0.5, KRedColor);
    

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
    [self.view addSubview:self.mainTableView];
    
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
        btn.tag = 500+i;
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
        btn.tag = 400+i;
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
    _pinglunArray = @[@"同事介绍来的，给家人都算了一遍，很专业,很好，我很喜欢，谢谢大师",
                      @"很专业，起到了好名字",
                      @"起的名字很好，很有内涵，家人都很喜欢",
                      @"不错,下次我小妹的孩子还来这起名,谢谢！",
                      @"推荐的好名字太多了，都不知道选哪个好了，哈哈",
                      @"我弟弟说你们起的很专业，一个字，准！",
                      @"起名考虑的很周全，很符合古典的风格，适合大部分喜欢中国古文化的家庭",
                      @"这个应用我给满分！",
                      @"每个名字的解释很详细，以后我女儿问我，我就这么跟他解释",
                      @"李之童，好名字，我要了",
                      ];
    _phoneArray = @[@"20215648510",
                    @"20204512845",
                    @"20190302445",
                    @"20213254512",
                    @"20212340100",
                    @"20200345215",
                    @"20219978010",
                    @"20200201086",
                    @"20213202451",
                    @"20214512451",];
    _imageArray = @[@"21",
                    @"22",
                    @"23",
                    @"24",
                    @"25",
                    @"22",
                    @"23",
                    @"24",
                    @"21",
                    @"25",
                    ];
    
}
-(UITableView *)mainTableView{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kScreenHeight-HitoTabBarHeight-kTopHeight-220, KScreenWidth, 210) style:UITableViewStylePlain];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.userInteractionEnabled = NO;
        _mainTableView.backgroundColor = KClearColor;
        
    }
    return _mainTableView;
}
#pragma mark ---日期选择按钮点击---
- (void)dataButtonClicked{
    [self.textfile1.inputText resignFirstResponder];
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
        self->_textfile2.inputText.backgroundColor = RGB(244, 240, 232);

    };
//    [BAKit_PickerView ba_creatPickerViewWithType:BAKit_PickerViewTypeDate configuration:^(BAKit_PickerView *tempView) {
//
//        // 可以自由定制 NSDateFormatter
//        tempView.dateMode = BAKit_PickerViewDateModeDate;
//        tempView.dateType = BAKit_PickerViewDateTypeYMD;
//
//        // 可以自由定制按钮颜色
//        tempView.ba_buttonTitleColor_sure = [UIColor redColor];
//        tempView.ba_buttonTitleColor_cancle = [UIColor redColor];
//        tempView.animationType = BAKit_PickerViewAnimationTypeBottom;
//
//
//    } block:^(NSString *resultString) {
//        NSLog(@"%@",resultString);
//        self.dateStr = resultString;
//        self->_textfile2.inputText.backgroundColor = RGB(244, 240, 232);
//
//        self->_textfile2.inputText.text = resultString;
//    }];
}

#pragma mark ---确定按钮---
-(void)makesureBtnClicked{
    if (self.dateStr.length==0||self.textfile1.inputText.text.length==0) {
//        [MBProgressHUD showWarnMessage:@"请正确输入您的信息"];
        [SVProgressHUD showInfoWithStatus:@"请正确输入您的信息"];
    }else{
        _xingStr = self.textfile1.inputText.text;
        [self getNetWorking];
    }

    
    DLog(@"确定按钮%@,%@,%@,%@",_nametype,_sextype,self.textfile1.inputText.text,_dateStr);
}
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

    [manager POST:[baseUrl stringByAppendingString:urlStr] parameters:dic headers:@{} progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSDictionary *dateDic = (NSDictionary *)responseObject;
            self.bazi_id = dateDic[@"data"][@"bazi_id"];
            [self goDetailController];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
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
-(void)goDetailController{
    LWNameListViewController *namelistVC = [[LWNameListViewController alloc] init];
    namelistVC.bazi_id = self.bazi_id;
    namelistVC.firstname = self.xingStr;
    namelistVC.name_type = self.nametype;
    namelistVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:namelistVC animated:YES];
    
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
    if (textField.text.length <= 0 && textField.tag ==200) {
        [_textfile1 textBeginEditing];
    }else if (textField.text.length <= 0 && textField.tag ==201){
        [_textfile2 textEndEditing];
        
    }
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.text.length <= 0 && textField.tag ==200) {
        [_textfile1 textEndEditing];
    }else if (textField.text.length <= 0 && textField.tag ==201){
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 100;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"CELL"];
    }
    NSInteger i = indexPath.row%10;
    cell.imageView.size = CGSizeMake(40, 40);
    cell.imageView.centerY = cell.centerY;
    cell.imageView.image = IMAGE_NAMED(_imageArray[i]);
    cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
    ViewRadius(cell.imageView, 20);
    cell.textLabel.text = _pinglunArray[i];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.numberOfLines = 0;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"订单号  %@  评论:",_phoneArray[i]];
    cell.backgroundColor = KClearColor;
    cell.selectionStyle= UITableViewCellSelectionStyleNone;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 30)];
    label.font = [UIFont systemFontOfSize:14.0f];
    label.text = @"用户反馈  ↓  ";
    label.textColor = KRedColor;
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = KClearColor;
    return label;
}

-(void)viewWillAppear:(BOOL)animated{
    _mytimer = [NSTimer timerWithTimeInterval:3.0 target:self selector:@selector(timerMethod) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.mytimer forMode:NSRunLoopCommonModes];
    self.navigationController.navigationBar.translucent = NO;

}
-(void)viewWillDisappear:(BOOL)animated{
    _intTime=0;
    [_mytimer invalidate];
    self.navigationController.navigationBar.translucent = YES;

}
- (void)timerMethod{
    if (_intTime<99) {
        _intTime++;
        [self.mainTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_intTime inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }else{
        _intTime=0;
        [_mytimer invalidate];
    }
    
}


@end
