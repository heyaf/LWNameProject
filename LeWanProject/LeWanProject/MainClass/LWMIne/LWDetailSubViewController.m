//
//  LWDetailSubViewController.m
//  LeWanProject
//
//  Created by iOS on 2021/3/17.
//  Copyright © 2021 mac. All rights reserved.
//

#import "LWDetailSubViewController.h"

@interface LWDetailSubViewController ()

@end

@implementation LWDetailSubViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = KWhiteColor;
    self.navigationItem.title = self.Title;
    
    UITextView *textfile = [[UITextView alloc] initWithFrame:CGRectMake(10, 10, KScreenWidth-20, KScreenHeight-20)];
    textfile.userInteractionEnabled = NO;
    
    textfile.text = self.message;
    textfile.font = SYSTEMFONT(15.0);
    [self.view addSubview:textfile];
    
    UIButton *button = [UIButton buttonWithType:0];
    [button setTitle:@"点击复制客服微信" forState:0];
//    button.frame = CGRectMake(0, 0, 120, 20);
    button.titleLabel.font = SYSTEMFONT(13.0);
    [button setTitleColor:KBlackColor forState:0];
    ViewBorderRadius(button, 5, .5, KRedColor);
    [button addTarget:self action:@selector(ButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    rightItem.imageInsets = UIEdgeInsetsMake(0, 0,0, 0);//设置向左偏移
    
    if ([self.hasKefu isEqualToString:@"YES"]) {
        self.navigationItem.rightBarButtonItem = rightItem;
    }
}
- (void)ButtonClicked{
    [UIPasteboard generalPasteboard].string =@"ccc666888ooo";
    [SVProgressHUD showSuccessWithStatus:@"客服微信号已复制到粘贴板"];
}


@end
