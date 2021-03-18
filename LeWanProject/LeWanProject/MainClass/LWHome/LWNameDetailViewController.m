//
//  LWNameDetailViewController.m
//  LeWanProject
//
//  Created by iOS on 2021/3/17.
//  Copyright © 2021 mac. All rights reserved.
//

#import "LWNameDetailViewController.h"
#import "LWNameModel.h"
#import "CQScrollMenuView.h"
#import "UIView+frameAdjust.h"
#import "ZScrollLabel.h"
@interface LWNameDetailViewController ()<CQScrollMenuViewDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) CQScrollMenuView *menuView;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic, strong) ZScrollLabel *contentLabel;

PropertyString(pingfen);
PropertyString(ziyi);
PropertyString(bazixishen);
PropertyNSMutableArray(sancaiMutArr);
PropertyString(Wugexijie);

PropertyString(shengxiao); //生肖
PropertyString(shengxiaoYY); //生肖宜用
PropertyString(shengxiaoJY); //生肖忌用

@end

@implementation LWNameDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = KWhiteColor;
    

    
    self.navigationItem.title = @"解析";
    self.contentLabel.text = @"名字不理想？大师提醒：改个大吉名平时多用，不改身份证也会有效促进好运";
    [self.view addSubview:self.contentLabel];
 
    // 创建滚动菜单栏
    self.menuView = [[CQScrollMenuView alloc]initWithFrame:CGRectMake(0, kTopHeight+10, self.view.width, 30)];
    [self.view addSubview:self.menuView];
    self.menuView.menuButtonClickedDelegate = self;
    self.menuView.titleArray = @[@"字词释义",@"三才五格",@"生肖属相",@"其他案例"];
    
    // tableView
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kTopHeight+10+30, self.view.width, KScreenHeight - (kTopHeight+10+30+20)) style:UITableViewStyleGrouped];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    
    [self creatNameListNetWorking];
}

- (ZScrollLabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[ZScrollLabel alloc] initWithFrame:CGRectMake(10, KScreenHeight-20, self.view.frame.size.width-20, 15)];
        _contentLabel.textColor = KRedColor;
        _contentLabel.font = [UIFont systemFontOfSize:13.0f];
        _contentLabel.layer.borderWidth = 0.5;
        _contentLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _contentLabel.layer.cornerRadius = 3.0;
    }
    return _contentLabel;
}
- (void)creatNameListNetWorking{
    [[SCCatWaitingHUD sharedInstance] animateWithInteractionEnabled:NO];
    [FGRequestCenter sendRequest:^(FGRequestItem * _Nonnull item) {
        //请求的路径
        item.api = @"jieming";
        //配置请求的参数
        item.parameters = @{
                            @"first_name":self.xing,
                            @"last_name":self.mingzi,
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
        [[SCCatWaitingHUD sharedInstance] stop];

        self.namemodel = [LWNameModel modelWithDictionary:responseObject[@"name"]];
        self.pingfen = responseObject[@"sanCai"][@"JiXiong"];
        NSArray *ziyiArr = responseObject[@"ziyi"];
        self.ziyi= @"";
        for (int i=0; i<ziyiArr.count; i++) {
            NSDictionary *ziyiDic = ziyiArr[i];
            if (i==0) {
                self.ziyi = [self.ziyi stringByAppendingString:NSStringFormat(@"%@",ziyiDic[@"title"])];
            }else{
                self.ziyi = [self.ziyi stringByAppendingString:NSStringFormat(@"\n\n\n%@",ziyiDic[@"title"])];
            }
            
            self.ziyi = [self.ziyi stringByAppendingString:NSStringFormat(@"\n %@",ziyiDic[@"content"])];
        }
        self.bazixishen = NSStringFormat(@"八字喜用的建议：\n\n%@",responseObject[@"zongGe"][@"bazixishen"]);
        
        NSArray *sancaiArr = responseObject[@"scwgxj"][@"content"];
        self.sancaiMutArr = [NSMutableArray arrayWithCapacity:0];
        for (int i=0; i<sancaiArr.count; i++) {
            NSDictionary *sancaiDic = sancaiArr[i];
            NSMutableAttributedString *str= [[NSMutableAttributedString alloc] initWithString:NSStringFormat(@"%@\n%@",sancaiDic[@"title"],sancaiDic[@"detail"])];
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0,2)];
            
            [self.sancaiMutArr addObject:str];
        }
        
        self.Wugexijie = @"";
        
        self.Wugexijie = [self.Wugexijie stringByAppendingString:NSStringFormat(@"%@",responseObject[@"wgxj"][@"di"][@"content"])];
        self.Wugexijie = [self.Wugexijie stringByAppendingString:NSStringFormat(@"\n\n%@",responseObject[@"wgxj"][@"ren"][@"content"])];
        self.Wugexijie = [self.Wugexijie stringByAppendingString:NSStringFormat(@"\n\n%@",responseObject[@"wgxj"][@"zong"][@"content"])];
        self.Wugexijie = [self.Wugexijie stringByAppendingString:NSStringFormat(@"\n\n%@",responseObject[@"wgxj"][@"wai"][@"content"])];
        self.Wugexijie = [self.Wugexijie stringByAppendingString:NSStringFormat(@"\n\n%@\n",responseObject[@"wgxj"][@"tian"][@"content"])];
        
        self.shengxiaoYY = responseObject[@"zodiac"][@"xiYong"];
        self.shengxiaoJY = responseObject[@"zodiac"][@"jiYong"];
        self.shengxiao = responseObject[@"orderInfo"][@"shengXiao"];
        
        [self.tableView reloadData];
        DLog(@"-%@",responseObject);
    } onFailure:^(NSError * _Nullable error) {
        [SVProgressHUD showErrorWithStatus:@"网络请求失败，请稍后重试"];
        [[SCCatWaitingHUD sharedInstance] stop];

    } onFinished:^(id  _Nullable responseObject, NSError * _Nullable error) {
        
    }];
    
    
    
}
#pragma mark - Delegate - 菜单栏
// 菜单按钮点击时回调
- (void)scrollMenuView:(CQScrollMenuView *)scrollMenuView clickedButtonAtIndex:(NSInteger)index{
    // tableView滚动到对应组
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:index];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
}

#pragma mark - UITableView DataSource & Delegate

// cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuseCellID = @"ReuseCellID";
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseCellID];
    if (indexPath.section==0&&indexPath.row==0) {
        [cell removeAllSubviews];

        [cell addSubview:[self firstHeaderView]];
    }else if(indexPath.row==1&&indexPath.section==0){
        cell.textLabel.text = self.ziyi;
        cell.textLabel.font = SYSTEMFONT(15.0);
        cell.textLabel.numberOfLines = 0;
    }else if (indexPath.section==0&&indexPath.row==2){
        cell.textLabel.text = self.bazixishen;;
        cell.textLabel.font = SYSTEMFONT(14.0);
        cell.textLabel.numberOfLines = 0;
    }else if (indexPath.section==3&&indexPath.row==0){
        UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenWidth)];
        [cell addSubview:imageV];
        imageV.image = IMAGE_NAMED(@"anli");

    }else if (indexPath.section==1&&indexPath.row==0){
        cell.textLabel.text = @"三才解析：";
        cell.textLabel.textColor = KRedColor;
        cell.textLabel.font = SYSTEMFONT(16.0);
        cell.textLabel.numberOfLines = 0;
    }else if (indexPath.section==1&&indexPath.row==self.sancaiMutArr.count+1){
        cell.textLabel.text = @"五格解析：";
        cell.textLabel.textColor = KRedColor;
        cell.textLabel.font = SYSTEMFONT(16.0);
        cell.textLabel.numberOfLines = 0;
    }else if (indexPath.section==1&&indexPath.row==self.sancaiMutArr.count+2){
        cell.textLabel.text = self.Wugexijie;
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.font = SYSTEMFONT(14.0);
        cell.textLabel.numberOfLines = 0;
    }else if (indexPath.section==1){
        cell.textLabel.attributedText = self.sancaiMutArr[indexPath.row-1];
        cell.textLabel.font = SYSTEMFONT(14.0);
        cell.textLabel.numberOfLines = 0;
    }else if (indexPath.section==2&&indexPath.row==1){
        cell.textLabel.text = self.shengxiaoYY;
        cell.textLabel.font = SYSTEMFONT(14.0);
        cell.textLabel.numberOfLines = 0;
    }else if (indexPath.section==2&&indexPath.row==3){
        cell.textLabel.text = self.shengxiaoJY;
        cell.textLabel.font = SYSTEMFONT(14.0);
        cell.textLabel.numberOfLines = 0;
    }else if (indexPath.section==2&&indexPath.row==0){
        cell.textLabel.text = NSStringFormat(@"【%@】喜用",self.shengxiao);
        cell.textLabel.textColor = KRedColor;
        cell.textLabel.font = SYSTEMFONT(16.0);
        cell.textLabel.numberOfLines = 0;
    }else if (indexPath.section==2&&indexPath.row==2){
        cell.textLabel.text = NSStringFormat(@"【%@】忌用",self.shengxiao);
        cell.textLabel.textColor = KRedColor;
        cell.textLabel.font = SYSTEMFONT(16.0);
        cell.textLabel.numberOfLines = 0;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0&&indexPath.section==0) {
        return 80;
    }else if (indexPath.section==3&&indexPath.row==0){
        return KScreenWidth;
    }
    return UITableViewAutomaticDimension;
}

// 行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==1) {
        return self.sancaiMutArr.count+3;
    }else if (section==2){
        return 4;
    }else if (section==3){
        return 1;
    }
    return 3;
}

// 组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.menuView.titleArray.count;
}

// 组头
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    static NSString *reuseHeaderID = @"ReuseHeaderID";
    UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:reuseHeaderID];
    if (headerView == nil) {
        headerView = [[UITableViewHeaderFooterView alloc]initWithReuseIdentifier:reuseHeaderID];
    }
    
    return headerView;
}

// 组头高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5;
}

// 组头标题
//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//    return [NSString stringWithFormat:@"第%ld组",section];
//}

// 组头将要展示时回调
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{
    self.menuView.currentButtonIndex = section;
}
- (UIView *)firstHeaderView{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 80)];
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(50, 3, KScreenWidth-100, 15)];
    label1.text = self.namemodel.pinYin;
    label1.textColor = KGrayColor;
    label1.font = SYSTEMFONT(13.0);
    label1.textAlignment = NSTextAlignmentCenter;
    [view addSubview:label1];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(50, 30, KScreenWidth-100, 20)];
    label2.text = self.namemodel.jiMing;
    label2.textColor = KBlackColor;
    label2.font = SYSTEMFONT(16.0);
    label2.textAlignment = NSTextAlignmentCenter;
    [view addSubview:label2];
    
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(50, 60, KScreenWidth-100, 15)];
    label3.text = self.namemodel.wuXing;
    label3.textColor = KGray2Color;
    label3.font = SYSTEMFONT(13.0);
    label3.textAlignment = NSTextAlignmentCenter;
    [view addSubview:label3];
    
    UILabel *label4 = [[UILabel alloc] initWithFrame:CGRectMake(25, 15, 50, 20)];
    label4.text = @"评分";
    label4.textColor = KGrayColor;
    label4.font = SYSTEMFONT(15.0);
    label4.textAlignment = NSTextAlignmentCenter;
    [view addSubview:label4];
    ViewBorderRadius(label4, 10, 1, KGrayColor);
    
    UILabel *label5 = [[UILabel alloc] initWithFrame:CGRectMake(0, 45, 100, 15)];
    label5.text = self.pingfen;
    label5.textColor = KRedColor;
    label5.font = SYSTEMFONT(16.0);
    label5.textAlignment = NSTextAlignmentCenter;
    [view addSubview:label5];
    
    ViewBorderRadius(view, 0, 0.3, KGrayColor);
    return view;
}

@end
