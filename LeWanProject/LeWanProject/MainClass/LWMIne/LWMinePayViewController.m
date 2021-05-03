//
//  LWMinePayViewController.m
//  LeWanProject
//
//  Created by mac on 2021/5/2.
//  Copyright © 2021 mac. All rights reserved.
//

#import "LWMinePayViewController.h"
#import "WGInPurchaseController.h"
@interface LWMinePayViewController ()<WGInPurchaseControllerDelegate>

@property (nonatomic,strong) WGInPurchaseController *purchaseVC;
@end

@implementation LWMinePayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"购买纯净版";
    self.view.backgroundColor = KWhiteColor;
    
    UITextView *textfile = [[UITextView alloc] initWithFrame:CGRectMake(10, kTopHeight+20, KScreenWidth-20, 50)];
    textfile.userInteractionEnabled = NO;
    
    textfile.text = @"VIP纯净版旨在给用户提供一个干净流畅的APP使用体验，您可以通过点击下方按钮购买↓";
    textfile.font = SYSTEMFONT(15.0);
    [self.view addSubview:textfile];
    
    UIButton *button = [UIButton buttonWithType:0];
    [button setTitle:@"点击购买" forState:0];
    [button setBackgroundImage:[UIImage imageNamed:@"payButtonClicked"] forState:0];
    button.frame = CGRectMake(0, 0, 120, 40);
    button.titleLabel.font = SYSTEMFONT(15.0);
    [button setTitleColor:KWhiteColor forState:0];

    button.center = self.view.center;
    [button addTarget:self action:@selector(ButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:button];
    self.purchaseVC = [WGInPurchaseController controller];
    self.purchaseVC.delegate = self;
}
-(void)ButtonClicked{
    [self.purchaseVC didClickProduct];
    
}
-(void)didInPurchaseSucceedWithInPurchaseController:(__kindof WGInPurchaseController *)inPurchaseController{
    [kUserDefaults setBool:YES forKey:kVIPPaySuc];
    
    [SVProgressHUD showSuccessWithStatus:@"购买成功"];
    [self.navigationController popViewControllerAnimated:YES];
}
@end
